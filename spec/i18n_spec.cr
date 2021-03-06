require "./spec_helper"
require "../src/i18n"
require "../src/i18n/backends/hash"
require "../src/i18n/backends/json"
require "../src/i18n/backends/yaml"

macro define_i18n_tests
  describe "#t" do
    it "works" do
      I18n.t("hello.world").should eq "Hello world!"
    end

    it "works with count" do
      I18n.t("apples", count: 3).should eq "3 apples"
    end

    it "works with locale" do
      I18n.t("hello.world", "es").should eq "Saluton mondo!"
    end

    it "works with locale and count" do
      I18n.t("apples", "es", count: 3).should eq "3 manzanas"
    end

    it "handles missing keys" do
      I18n.t("unknown.key").should eq "MISSING: en.unknown.key"
    end
  end
end

describe I18n do
  context "with Hash backend" do
    I18n.backend = I18n::Backends::Hash.new({"en" => {"hello" => {"world" => "Hello world!"}, "apples" => {"one" => "1 apple", "other" => "%{count} apples"}}, "es" => {"hello" => {"world" => "Saluton mondo!"}, "apples" => {"one" => "1 manzana", "other" => "%{count} manzanas"}}})

    define_i18n_tests
  end

  context "with JSON backend" do
    I18n.backend = I18n::Backends::JSON.new.tap do |backend|
      backend.load_paths << Dir.current + "/locales"
      backend.load
    end

    define_i18n_tests
  end

  context "with YAML backend" do
    I18n.backend = I18n::Backends::YAML.new.tap do |backend|
      backend.load_paths << Dir.current + "/locales"
      backend.load
    end

    define_i18n_tests
  end
end
