defmodule LambdaCache.MixProject do
  use Mix.Project

  def project do
    [
      app: :lambda_cache,
      deps: [
        {:dialyxir, "~> 0.5", only: :dev, runtime: false},
        {:ex_doc, "~> 0.18.0", only: :dev, runtime: false}
      ],
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
      package: [
        description: "Zero-arity function polling cache",
        files: ["lib", "mix.exs", "README.md"],
        licenses: ["CC0-1.0"],
        links: %{"GitHub" => "https://github.com/serokell/lambda_cache"},
        maintainers: ["Yegor Timoshenko"]
      ],
      version: "0.1.0"
    ]
  end
end
