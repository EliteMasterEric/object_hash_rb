# frozen_string_literal: true

require "json"

RSpec.describe ObjectHash do
  context "meta" do
    it "exists" do
      expect(ObjectHash).to be_a Module
    end

    it "has a version number" do
      expect(ObjectHash::VERSION).not_to be nil
    end
  end

  context "cryptohash" do
    it "exists" do
      expect(ObjectHash::CryptoHash).to be_a Module
    end

    it "has main method" do
      expect(ObjectHash::CryptoHash.respond_to?(:perform_cryptohash)).to be true
    end

    it "hashes with 'none'" do
      # Simple strings.
      expect(ObjectHash::CryptoHash.perform_cryptohash("Hello World", "passthrough"))
        .to eq "Hello World"
      expect(ObjectHash::CryptoHash.perform_cryptohash("Testing", "passthrough"))
        .to eq "Testing"

      # Complex strings.
      expect(ObjectHash::CryptoHash.perform_cryptohash("~9~N45u7k`25YfN", "passthrough"))
        .to eq "~9~N45u7k`25YfN"
    end

    it "hashes with 'md5'" do
      # Simple strings.
      expect(ObjectHash::CryptoHash.perform_cryptohash("Hello World", "md5"))
        .to eq "B10A8DB164E0754105B7A99BE72E3FE5"
      expect(ObjectHash::CryptoHash.perform_cryptohash("Testing", "md5"))
        .to eq "FA6A5A3224D7DA66D9E0BDEC25F62CF0"

      # Complex strings.
      expect(ObjectHash::CryptoHash.perform_cryptohash("~9~N45u7k`25YfN", "md5"))
        .to eq "B1D23E92707A7607893E92E2ADBE6B43"
    end

    it "hashes with 'sha1'" do
      # Simple strings.
      expect(ObjectHash::CryptoHash.perform_cryptohash("Hello World", "sha1"))
        .to eq "0A4D55A8D778E5022FAB701977C5D840BBC486D0"
      expect(ObjectHash::CryptoHash.perform_cryptohash("Testing", "sha1"))
        .to eq "0820B32B206B7352858E8903A838ED14319ACDFD"

      # Complex strings.
      expect(ObjectHash::CryptoHash.perform_cryptohash("~9~N45u7k`25YfN", "sha1"))
        .to eq "CBF59A0CB5A9C32EFD19EA8926C28D89D87D6D12"
    end

    it "hashes with 'sha2'" do
      # Simple strings.
      expect(ObjectHash::CryptoHash.perform_cryptohash("Hello World", "sha2"))
        .to eq "A591A6D40BF420404A011733CFB7B190D62C65BF0BCDA32B57B277D9AD9F146E"
      expect(ObjectHash::CryptoHash.perform_cryptohash("Testing", "sha2"))
        .to eq "E806A291CFC3E61F83B98D344EE57E3E8933CCCECE4FB45E1481F1F560E70EB1"

      # Complex strings.
      expect(ObjectHash::CryptoHash.perform_cryptohash("~9~N45u7k`25YfN", "sha2"))
        .to eq "F1EA688AC812EBDF4EB8E78A29CC01AABE5BFF0F9205A1847C81A24223FA3849"
    end

    it "hashes with 'sha256'" do
      # Simple strings.
      expect(ObjectHash::CryptoHash.perform_cryptohash("Hello World", "sha256"))
        .to eq "A591A6D40BF420404A011733CFB7B190D62C65BF0BCDA32B57B277D9AD9F146E"
      expect(ObjectHash::CryptoHash.perform_cryptohash("Testing", "sha256"))
        .to eq "E806A291CFC3E61F83B98D344EE57E3E8933CCCECE4FB45E1481F1F560E70EB1"

      # Complex strings.
      expect(ObjectHash::CryptoHash.perform_cryptohash("~9~N45u7k`25YfN", "sha256"))
        .to eq "F1EA688AC812EBDF4EB8E78A29CC01AABE5BFF0F9205A1847C81A24223FA3849"
    end

    it "hashes with 'rmd160'" do
      # Simple strings.
      expect(ObjectHash::CryptoHash.perform_cryptohash("Hello World", "rmd160"))
        .to eq "A830D7BEB04EB7549CE990FB7DC962E499A27230"
      expect(ObjectHash::CryptoHash.perform_cryptohash("Testing", "rmd160"))
        .to eq "01743C6E71742ED72D6C51537F1790A462B82C82"

      # Complex strings.
      expect(ObjectHash::CryptoHash.perform_cryptohash("~9~N45u7k`25YfN", "rmd160"))
        .to eq "D8F8A76D4F6E00DF9D140A68A36E155D60CEB545"
    end

    it "can't hash with unknown algorithms" do
      # Simple strings.
      expect { ObjectHash::CryptoHash.perform_cryptohash("Hello World", "test") }
        .to raise_error UnknownAlgorithmError
      expect { ObjectHash::CryptoHash.perform_cryptohash("Testing", "123") }
        .to raise_error UnknownAlgorithmError

      # Complex strings.
      expect { ObjectHash::CryptoHash.perform_cryptohash("~9~N45u7k`25YfN", "Mk8SGz`g") }
        .to raise_error UnknownAlgorithmError
    end
  end

  def encode(input)
    ObjectHash::Encode::Encoder.new.perform_encode(input)
  end

  context "encode" do
    it "exists" do
      expect(ObjectHash::Encode).to be_a Module
    end

    it "has encoder class" do
      expect(ObjectHash::Encode::Encoder)
    end

    it "has main method" do
      expect(ObjectHash::Encode::Encoder.new.respond_to?(:perform_encode)).to be true
    end

    it "encodes numbers" do
      # Integers
      expect(encode(123))
        .to eq "number:123"
      expect(encode(42_069))
        .to eq "number:42069"

      # Floats
      expect(encode(420.69))
        .to eq "number:420.69"
    end

    it "encodes strings" do
      # Simple Strings
      expect(encode("Hello World"))
        .to eq "string:11:Hello World"
      expect(encode("Testing"))
        .to eq "string:7:Testing"

      # Complex Strings
      expect(encode("~9~N45u7k`25YfN"))
        .to eq "string:15:~9~N45u7k`25YfN"
      expect(encode("~9~N45:u7k`25YfN"))
        .to eq "string:16:~9~N45:u7k`25YfN"
    end

    it "encodes booleans" do
      # True
      expect(encode(true))
        .to eq "bool:true"

      # False
      expect(encode(false))
        .to eq "bool:false"
    end

    it "encodes arrays" do
      # Specify each element.
      expect(encode([1, 2, 3]))
        .to eq "array:3:number:1number:2number:3"

      # Order should matter here.
      expect(encode([3, 2, 1]))
        .to eq "array:3:number:3number:2number:1"

      # Allow mixed types.
      expect(encode(["Testing", 420, true, "Cool"]))
        .to eq "array:4:string:7:Testingnumber:420bool:truestring:4:Cool"
    end

    it "encodes hashes" do
      # Specify each element.
      expect(encode({ "a" => 1, "b" => 2, "c" => 3 }))
        .to eq "object:3:string:1:a:number:1,string:1:b:number:2,string:1:c:number:3,"

      # Order should NOT matter here.
      expect(encode({ "c" => 1, "a" => 2, "b" => 3 }))
        .to eq "object:3:string:1:a:number:2,string:1:b:number:3,string:1:c:number:1,"

      # Symbol keys work too.
      expect(encode({ a: 1, b: 2, c: 3 }))
        .to eq "object:3:symbol:a:number:1,symbol:b:number:2,symbol:c:number:3,"

      # Allow mixed types.
      expect(encode({
        "carl" => "Testing",
        "ben" => 420,
        "amber" => true,
        "foo" => "Cool",
        "bar" => [1, 3, 2]
      }))
        .to eq "object:5:string:5:amber:bool:true,string:3:bar:array:3:number:1number:3number:2,"\
          "string:3:ben:number:420,string:4:carl:string:7:Testing,string:3:foo:string:4:Cool,"

      # JSON data should encode like a hash.
      expect(encode(JSON.parse('{"hello": "goodbye"}')))
        .to eq "object:1:string:5:hello:string:7:goodbye,"
    end

    it "encodes dates" do
      # Can encode Times.
      expect(encode(Time.new(2008, 6, 21, 13, 30, 0)))
        .to eq "date:2008-06-21T13:30:00.000Z"

      # Can encode DateTimes.
      expect(encode(DateTime.new(2001, 2, 3, 4, 5, 6)))
        .to eq "date:2001-02-03T04:05:06.000Z"
    end

    it "encodes circular references" do
      test_circular_ref = {
        "hello" => "goodbye",
        "cool" => {
          "foo" => "bar"
        }
      }
      test_circular_ref["cool"]["beans"] = test_circular_ref

      expect(encode(test_circular_ref))
        .to eq "object:2:string:4:cool:object:2:string:5:beans:string:12:[CIRCULAR:0],"\
          "string:3:foo:string:3:bar,,string:5:hello:string:7:goodbye,"
    end

    it "encodes nil" do
      # Should output Undefined.
      expect(encode(nil))
        .to eq "Null"
    end

    it "has option: unordered_objects" do
      # @unordered_objects
      # Order SHOULD matter here.
      expect(ObjectHash::Encode::Encoder.new(unordered_objects: false)
        .perform_encode({ "c" => 1, "a" => 2, "b" => 3 }))
        .to eq "object:3:string:1:c:number:1,string:1:a:number:2,string:1:b:number:3,"
    end

    it "has option: replacer" do
      # @replacer
      # Create a test class, which currently has no encoder.
      class TestStuff
        def generate_name
          "foobar"
        end
      end

      # Expect it to fail without a custom replacer.
      expect { ObjectHash::Encode::Encoder.new.perform_encode({ "a" => TestStuff.new }) }
        .to raise_error NoEncoderError

      # Expect it to succeed once a replacer is implemented.
      expect(ObjectHash::Encode::Encoder.new(replacer: lambda do |x|
        return x.generate_name if x.instance_of? TestStuff

        x
      end)
        .perform_encode({ "a" => TestStuff.new }))
        .to eq "object:1:string:1:a:string:6:foobar,"
    end
  end

  context "main" do
    it "has main method" do
      expect(ObjectHash.respond_to?(:hash)).to be true
    end

    it "hashes numbers" do
      # Integers
      expect(ObjectHash.hash(123))
        .to eq "7D37103E1C4D22DE8F7B4096B4BE8C2DDFA4CAA0"
      expect(ObjectHash.hash(42_069))
        .to eq "A17A249DA1AD565EADBDE4942A6AD086F255D814"

      # Floats
      expect(ObjectHash.hash(420.69))
        .to eq "5BFB9B3AEB735889106429F18DFB93B537E83A81"
    end

    it "hashes strings" do
      # Simple Strings
      expect(ObjectHash.hash("Hello World"))
        .to eq "3415EF7FD82C1A04DEA35838ED84A6CECB03C790"
      expect(ObjectHash.hash("Testing"))
        .to eq "F510B2407FECB05B35F4A618D648D6E344E9D337"

      # Complex Strings
      expect(ObjectHash.hash("~9~N45u7k`25YfN"))
        .to eq "668D99BEBCCF082D4C9F5BCA51631DEF580825F5"
      expect(ObjectHash.hash("~9~N45:u7k`25YfN"))
        .to eq "659533337978E2D14A25A398954C7EA0B200E62A"
    end

    it "hashes booleans" do
      # True
      expect(ObjectHash.hash(true))
        .to eq "CDF22D2A18B96EF07F6105CD8093AE12A8772CB3"

      # False
      expect(ObjectHash.hash(false))
        .to eq "B29C63990DEA846689120516761DE20C056E3539"
    end

    it "hashes arrays" do
      # Specify each element.
      expect(ObjectHash.hash([1, 2, 3]))
        .to eq "A2FC48DA101B2469CBB9B3E4C38E01E0C45BA127"

      # Order should matter here.
      expect(ObjectHash.hash([3, 2, 1]))
        .to eq "9853C3F2FB26D19928986C96A22A5D0DCDD2CFEF"

      # Allow mixed types.
      expect(ObjectHash.hash(["Testing", 420, true, "Cool"]))
        .to eq "1FE62E3EC91BCB6F007177C0B49211BCED4C337E"
    end

    it "hashes hashes" do
      # Specify each element.
      expect(ObjectHash.hash({ "a" => 1, "b" => 2, "c" => 3 }))
        .to eq "CA8CE4FAC21446139F77E1AA26BF6569E2464176"

      # Order should NOT matter here.
      expect(ObjectHash.hash({ "c" => 1, "a" => 2, "b" => 3 }))
        .to eq "75C4ED5F10C73E207F10B09F9EBE490569B84E8B"

      # Symbol keys work too.
      expect(ObjectHash.hash({ a: 1, b: 2, c: 3 }))
        .to eq "86BFBAADC95B656DCA2BF2393EF310A1983D59CB"

      # Allow mixed types.
      expect(ObjectHash.hash({
        "carl" => "Testing",
        "ben" => 420,
        "amber" => true,
        "foo" => "Cool",
        "bar" => [1, 3, 2]
      }))
        .to eq "4EB6DD799B2F817D023B14E38AE62D3FC045AE77"

      # JSON data should encode like a hash.
      expect(ObjectHash.hash(JSON.parse('{"hello": "goodbye"}')))
        .to eq "FA4E73D9BE70EEF528FFBC534C9A39DDF42E6446"
    end

    it "hashes dates" do
      # Can encode Times.
      expect(ObjectHash.hash(Time.new(2008, 6, 21, 13, 30, 0)))
        .to eq "A314B73DA2FCF9428C117A1D7E1E61082D4DC9B9"

      # Can encode DateTimes.
      expect(ObjectHash.hash(DateTime.new(2001, 2, 3, 4, 5, 6)))
        .to eq "0AD6F69D7447BC7375AAF93E5BA2C48EEC0D45C1"
    end

    it "hashes circular references" do
      test_circular_ref = {
        "hello" => "goodbye",
        "cool" => {
          "foo" => "bar"
        }
      }
      test_circular_ref["cool"]["beans"] = test_circular_ref

      expect(ObjectHash.hash(test_circular_ref))
        .to eq "AC8145D9066305B131C7DE60097568C5BDBCCDC5"
    end

    it "hashes nil" do
      # Should output Undefined.
      expect(ObjectHash.hash(nil))
        .to eq "109085BEAAA80AC89858B283A64F7C75D7E5BB12"
    end

    it "has option: unordered_objects" do
      # @unordered_objects
      # Order SHOULD matter here.
      expect(ObjectHash.hash({ "c" => 1, "a" => 2, "b" => 3 }, unordered_objects: false))
        .to eq "375AB995A945E850557429D9D5F63018845DE8EA"
    end

    it "has option: algorithm" do
      # @algorithm
      # Select a hashing algorithm.
      expect(ObjectHash.hash({ "c" => 1, "a" => 2, "b" => 3 }, algorithm: "md5"))
        .to eq "30B308454CE5B884D0D70905B744D2C8"
    end

    it "has option: replacer" do
      # @replacer
      # Create a test class, which currently has no encoder.
      class TestStuff
        def generate_name
          "foobar"
        end
      end

      # Expect it to fail without a custom replacer.
      expect { ObjectHash.hash({ "a" => TestStuff.new }) }
        .to raise_error NoEncoderError

      # Expect it to succeed once a replacer is implemented.
      expect(ObjectHash
        .hash({ "a" => TestStuff.new },
              replacer: lambda do |x|
                return x.generate_name if x.instance_of? TestStuff

                x
              end))
        .to eq "BD9525AC05617E0121CB8FA3E97AB62B80E33C27"
    end
  end
end
