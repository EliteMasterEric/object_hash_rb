# frozen_string_literal: true

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
      expect(ObjectHash::CryptoHash.perform_cryptohash("Hello World", "none"))
        .to eq "Hello World"
      expect(ObjectHash::CryptoHash.perform_cryptohash("Testing", "none"))
        .to eq "Testing"

      # Complex strings.
      expect(ObjectHash::CryptoHash.perform_cryptohash("~9~N45u7k`25YfN", "none"))
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

  context "encode" do
    it "exists" do
      expect(ObjectHash::Encode).to be_a Module
    end

    it "has main method" do
      expect(ObjectHash::Encode.respond_to?(:perform_encode)).to be true
    end

    it "encodes numbers" do
      # Integers
      expect(ObjectHash::Encode.perform_encode(123))
        .to eq "number:123"
      expect(ObjectHash::Encode.perform_encode(42_069))
        .to eq "number:42069"

      # Floats
      expect(ObjectHash::Encode.perform_encode(420.69))
        .to eq "number:420.69"
    end

    it "encodes strings" do
      # Simple Strings
      expect(ObjectHash::Encode.perform_encode("Hello World"))
        .to eq "string:11:Hello World"
      expect(ObjectHash::Encode.perform_encode("Testing"))
        .to eq "string:7:Testing"

      # Complex Strings
      expect(ObjectHash::Encode.perform_encode("~9~N45u7k`25YfN"))
        .to eq "string:15:~9~N45u7k`25YfN"
      expect(ObjectHash::Encode.perform_encode("~9~N45:u7k`25YfN"))
        .to eq "string:16:~9~N45:u7k`25YfN"
    end

    it "encodes booleans" do
      # True
      expect(ObjectHash::Encode.perform_encode(true))
        .to eq "bool:true"

      # False
      expect(ObjectHash::Encode.perform_encode(false))
        .to eq "bool:false"
    end

    it "encodes arrays" do
      # Specify each element.
      expect(ObjectHash::Encode.perform_encode([1, 2, 3]))
        .to eq "array:3:number:1number:2number:3"

      # Order should matter here.
      expect(ObjectHash::Encode.perform_encode([3, 2, 1]))
        .to eq "array:3:number:3number:2number:1"

      # Allow mixed types.
      expect(ObjectHash::Encode.perform_encode(["Testing", 420, true, "Cool"]))
        .to eq "array:4:string:7:Testingnumber:420bool:truestring:4:Cool"
    end

    it "encodes hashes" do
      # Specify each element.
      expect(ObjectHash::Encode.perform_encode({ "a" => 1, "b" => 2, "c" => 3 }))
        .to eq "object:3:string:1:a:number:1,string:1:b:number:2,string:1:c:number:3,"

      # Order should NOT matter here.
      expect(ObjectHash::Encode.perform_encode({ "c" => 1, "a" => 2, "b" => 3 }))
        .to eq "object:3:string:1:a:number:2,string:1:b:number:3,string:1:c:number:1,"

      # Allow mixed types.
      expect(ObjectHash::Encode.perform_encode({
        "carl" => "Testing",
        "ben" => 420,
        "amber" => true,
        "foo" => "Cool",
        "bar" => [1, 3, 2]
      }))
        .to eq "object:5:string:5:amber:bool:true,string:3:bar:array:3:number:1number:3number:2,"\
          "string:3:ben:number:420,string:4:carl:string:7:Testing,string:3:foo:string:4:Cool,"
    end

    it "encodes nil" do
      # Should output Undefined.
      expect(ObjectHash::Encode.perform_encode(nil))
        .to eq "Null"
    end
  end

  context "main" do
    it "has main method" do
      expect(ObjectHash.respond_to?(:hash)).to be true
    end

    it "hashes numbers in SHA1" do
      # Integers
      expect(ObjectHash.hash(123))
        .to eq "7D37103E1C4D22DE8F7B4096B4BE8C2DDFA4CAA0"
      expect(ObjectHash.hash(42_069))
        .to eq "A17A249DA1AD565EADBDE4942A6AD086F255D814"

      # Floats
      expect(ObjectHash.hash(420.69))
        .to eq "5BFB9B3AEB735889106429F18DFB93B537E83A81"
    end

    it "hashes strings in SHA1" do
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

    it "hashes booleans in SHA1" do
      # True
      expect(ObjectHash.hash(true))
        .to eq "CDF22D2A18B96EF07F6105CD8093AE12A8772CB3"

      # False
      expect(ObjectHash.hash(false))
        .to eq "B29C63990DEA846689120516761DE20C056E3539"
    end
  end
end
