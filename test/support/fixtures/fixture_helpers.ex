defmodule Blog.FixtureHelpers do
  @doc """
  Generates a random 8-byte string.
  """
  def gen_random_string(), do: Base.encode16(:crypto.strong_rand_bytes(8))
end