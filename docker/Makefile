packer    ?= packer


help: Makefile
	@echo
	@echo " Choose a command run in dotfiles:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo


## golang: Build and push golang images
.PHONY: golang
golang:
	@echo ">> ============= Golang ============= <<"
	@$(packer) build -var-file=hub.pkrvars.json images/go/prod.pkr.hcl
	@$(packer) build -var-file=hub.pkrvars.json images/go/1.16.build.pkr.hcl
	@$(packer) build -var-file=hub.pkrvars.json images/go/1.17.build.pkr.hcl
	@$(packer) build -var-file=hub.pkrvars.json images/go/1.18.build.pkr.hcl
	@$(packer) build -var-file=hub.pkrvars.json images/go/1.19.build.pkr.hcl


## rust: Build and push rust images
.PHONY: rust
rust:
	@echo ">> ============= Rust ============= <<"
	@$(packer) build -var-file=hub.pkrvars.json images/rust/prod.pkr.hcl
	@$(packer) build -var-file=hub.pkrvars.json images/rust/1.65.build.pkr.hcl


## elixir: Build and push elixir images
.PHONY: elixir
elixir:
	@echo ">> ============= Elixir ============= <<"
	@$(packer) build -var-file=hub.pkrvars.json images/elixir/1.13.prod.pkr.hcl


## erlang: Build and push erlang images
.PHONY: erlang
erlang:
	@echo ">> ============= Erlang ============= <<"
	@$(packer) build -var-file=hub.pkrvars.json images/erlang/25.prod.pkr.hcl


## init: Run init
.PHONY: init
init:
	@echo ">> ============= packer init ============= <<"
	@$(packer) init images/go/prod.pkr.hcl
	@$(packer) init images/go/1.16.build.pkr.hcl
	@$(packer) init images/go/1.17.build.pkr.hcl
	@$(packer) init images/go/1.18.build.pkr.hcl
	@$(packer) init images/go/1.19.build.pkr.hcl
	@$(packer) init images/rust/prod.pkr.hcl
	@$(packer) init images/rust/1.65.build.pkr.hcl
	@$(packer) init images/elixir/1.13.prod.pkr.hcl
	@$(packer) init images/erlang/25.prod.pkr.hcl


## fmt: Run fmt
.PHONY: fmt
fmt:
	@echo ">> ============= packer fmt ============= <<"
	@$(packer) fmt images/go/prod.pkr.hcl
	@$(packer) fmt images/go/1.16.build.pkr.hcl
	@$(packer) fmt images/go/1.17.build.pkr.hcl
	@$(packer) fmt images/go/1.18.build.pkr.hcl
	@$(packer) fmt images/go/1.19.build.pkr.hcl
	@$(packer) fmt images/rust/prod.pkr.hcl
	@$(packer) fmt images/rust/1.65.build.pkr.hcl
	@$(packer) fmt images/elixir/1.13.prod.pkr.hcl
	@$(packer) fmt images/erlang/25.prod.pkr.hcl


## check: Run check
.PHONY: check
check:
	@echo ">> ============= packer fmt ============= <<"
	@$(packer) fmt -check -diff images/go/prod.pkr.hcl
	@$(packer) fmt -check -diff images/go/1.16.build.pkr.hcl
	@$(packer) fmt -check -diff images/go/1.17.build.pkr.hcl
	@$(packer) fmt -check -diff images/go/1.18.build.pkr.hcl
	@$(packer) fmt -check -diff images/go/1.19.build.pkr.hcl
	@$(packer) fmt -check -diff images/rust/prod.pkr.hcl
	@$(packer) fmt -check -diff images/rust/1.65.build.pkr.hcl
	@$(packer) fmt -check -diff images/elixir/1.13.prod.pkr.hcl
	@$(packer) fmt -check -diff images/erlang/25.prod.pkr.hcl


## validate: Run validate
.PHONY: validate
validate:
	@echo ">> ============= packer validate ============= <<"
	@$(packer) validate images/go/prod.pkr.hcl
	@$(packer) validate images/go/1.16.build.pkr.hcl
	@$(packer) validate images/go/1.17.build.pkr.hcl
	@$(packer) validate images/go/1.18.build.pkr.hcl
	@$(packer) validate images/go/1.19.build.pkr.hcl
	@$(packer) validate images/rust/prod.pkr.hcl
	@$(packer) validate images/rust/1.65.build.pkr.hcl
	@$(packer) validate images/elixir/1.13.prod.pkr.hcl
	@$(packer) validate images/erlang/25.prod.pkr.hcl


## ci: Run ci
.PHONY: ci
ci: init check validate
	@echo "\n==> All quality checks passed"
