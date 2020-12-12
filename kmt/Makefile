cargo ?= cargo
rustup ?= rustup


help: Makefile
	@echo
	@echo " Choose a Command Run in Kmt:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo


## config: Install dependencies.
config:
	$(rustup) component add rustfmt


## doc: Generate docs.
doc:
	$(cargo) doc


## build: Build binary
build:
	@echo "\n>> ============= Cargo Build ============= <<"
	rm -rf target
	$(cargo) build --verbose --all


## release: Build releases
release:
	@echo "\n>> ============= Cargo Release ============= <<"
	rm -rf target
	$(cargo) build --release --verbose


## publish: Publish release
publish:
	@echo "\n>> ============= Cargo Publish ============= <<"
	$(cargo) publish


## test: Run test cases
test:
	@echo "\n>> ============= Cargo Test ============= <<"
	$(cargo) test --verbose --all


## fmt: Format code
fmt:
	@echo "\n>> ============= Cargo Format ============= <<"
	$(cargo) fmt


## fmt_check: Check format
fmt_check:
	@echo "\n>> ============= Cargo Format Check ============= <<"
	$(cargo) fmt -- --check


## run: Run project
run:
	@echo "\n>> ============= Cargo Run ============= <<"
	$(cargo) run


## ci: Run all CI tests.
ci: build test fmt_check
	@echo "\n>> ============= All quality checks passed ============= <<"


.PHONY: help
