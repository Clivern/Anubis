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
	@$(packer) build -var-file=hub.pkrvars.hcl images/go/generic.pkr.hcl


## rust: Build and push rust images
.PHONY: rust
rust:
	@echo ">> ============= Rust ============= <<"
	@$(packer) build -var-file=hub.pkrvars.hcl images/rust/generic.pkr.hcl


## ci: Run ci
.PHONY: ci
ci:
	@echo ">> ============= CI ============= <<"
	@$(packer) init images/go/generic.pkr.hcl
	@$(packer) init images/rust/generic.pkr.hcl
	@$(packer) fmt images/go/generic.pkr.hcl
	@$(packer) fmt images/rust/generic.pkr.hcl
	@$(packer) validate images/go/generic.pkr.hcl
	@$(packer) validate images/rust/generic.pkr.hcl
