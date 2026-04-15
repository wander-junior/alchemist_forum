# AlchemistForum

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Testing and Coverage

Run tests with:

```bash
mix test
```

Generate coverage reports using ExCoveralls:

```bash
# Basic coverage report (outputs to terminal)
mix coveralls

# Detailed coverage report with line-by-line analysis
mix coveralls.detail

# Generate HTML coverage report (saves to cover/ directory)
mix coveralls.html

# Generate JSON coverage report
mix coveralls.json

# Post coverage to a service (requires COVERALLS_REPO_TOKEN env var)
mix coveralls.post
```

All coveralls commands automatically run in the test environment as configured in `mix.exs`.

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
