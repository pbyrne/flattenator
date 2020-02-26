require "test_helper"

class HashLike
  def each_pair
    yield [:key, :value]
  end
end

describe Flattenator::Hash do
  describe "#initialize" do
    it "remembers the hash given to it" do
      hash = {foo: "bar"}
      subject = Flattenator::Hash.new(hash)

      assert_equal hash, subject.source
    end

    it "fails if not given a hash-y object" do
      assert_raises(ArgumentError) do
        Flattenator::Hash.new("")
      end
    end

    it "accepts non-hash objects that behave like hashes" do
      hash_like = HashLike.new
      subject = Flattenator::Hash.new(hash_like)

      assert_equal hash_like, subject.source
    end
  end

  describe "#flattened" do
    it "returns the original hash if it's not deeply nested" do
      source = {
        foo: "bar",
        bing: "bong",
      }
      flattened = {
        "foo" => "bar",
        "bing" => "bong",
      }
      subject = Flattenator::Hash.new(source)

      assert_equal flattened, subject.flattened
    end

    it "combines keys to create a flattened hash" do
      source = {
        foo: {
          bar: "baz",
          bing: "bong",
        },
        quux: "quuz",
      }
      flattened = {
        "foo_bar" => "baz",
        "foo_bing" => "bong",
        "quux" => "quuz",
      }
      subject = Flattenator::Hash.new(source, include_unflattened: false)

      assert_equal flattened, subject.flattened
    end

    it "creates foo_{0,1,…} keys to flatten arrays" do
      source = {
        fruits: [
          "apples",
          "bananas",
        ],
        vegetables: [
          "carrots",
          "daikon",
        ],
      }
      flattened = {
        "fruits_0" => "apples",
        "fruits_1" => "bananas",
        "vegetables_0" => "carrots",
        "vegetables_1" => "daikon",
      }
      subject = Flattenator::Hash.new(source, include_unflattened: false)

      assert_equal flattened, subject.flattened
    end

    it "flattens to arbitrary depths" do
      source = {
        foo: {
          bar: {
            baz: "quux",
            shapes: [
              "square",
              "circle",
            ],
          },
        },
      }
      flattened = {
        "foo_bar_baz" => "quux",
        "foo_bar_shapes_0" => "square",
        "foo_bar_shapes_1" => "circle",
      }
      subject = Flattenator::Hash.new(source, include_unflattened: false)

      assert_equal flattened, subject.flattened
    end

    it "includes a JSON-encoded version of the flattened hashes or arrays by default" do
      source = {
        foo: "bar",
        bing: {
          bang: "bong",
        },
        fruits: [
          "apple",
          "banana",
        ],
      }
      subject = Flattenator::Hash.new(source)

      assert_equal JSON.dump(source[:bing]), subject.flattened["bing"]
      assert_equal JSON.dump(source[:fruits]), subject.flattened["fruits"]
    end

    it "can optionally not include this JSON-encoded version of the flattened hashes or arrays" do
      source = {
        foo: "bar",
        bing: {
          bang: "bong",
        },
        fruits: [
          "apple",
          "banana",
        ],
      }
      subject = Flattenator::Hash.new(source, include_unflattened: false)

      refute subject.flattened.include?("bing")
      refute subject.flattened.include?("bong")
    end

    it "converts unhelpful characters into underscores" do
      source = {
        "foo-bar" => "baz",
      }
      flattened = {
        "foo_bar" => "baz",
      }
      subject = Flattenator::Hash.new(source)

      assert_equal flattened, subject.flattened
    end
  end
end
