defmodule BlogWeb.EndpointTest do
  use ExUnit.Case, async: true

  describe "init/2" do
    test "loads PORT from environment variable into config when load_from_system_env is set" do
      config = [load_from_system_env: true]
      System.put_env("PORT", "1234")
      expected = {:ok, [http: [:inet6, port: "1234"], load_from_system_env: true]}
      assert BlogWeb.Endpoint.init(:foo, config) == expected
    end
    
    test "does not load PORT from environment variable into config when load_from_system_env is not set" do
      config = []
      System.put_env("PORT", "1234")
      expected = {:ok, []}
      assert BlogWeb.Endpoint.init(:foo, config) == expected
    end
  end
end