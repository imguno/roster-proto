.PHONY: all go python node clean

# Paths to SDK repos (override if repos are in different locations)
GO_OUT     ?= ../roster-ai/roster/proto
PYTHON_OUT ?= ../roster-sdk-python/generated
NODE_OUT   ?= ../roster-sdk-node/generated

all: go python node

go:
	protoc --go_out=$(GO_OUT) --go_opt=paths=source_relative \
	       --go-grpc_out=$(GO_OUT) --go-grpc_opt=paths=source_relative \
	       agent.proto

python:
	python -m grpc_tools.protoc -I. \
	       --python_out=$(PYTHON_OUT) \
	       --grpc_python_out=$(PYTHON_OUT) \
	       --pyi_out=$(PYTHON_OUT) \
	       agent.proto

node:
	npx grpc_tools_node_protoc \
	       --js_out=import_style=commonjs,binary:$(NODE_OUT) \
	       --grpc_out=grpc_js:$(NODE_OUT) \
	       --proto_path=. \
	       agent.proto

clean:
	rm -f $(GO_OUT)/agent.pb.go $(GO_OUT)/agent_grpc.pb.go
	rm -f $(PYTHON_OUT)/agent_pb2.py $(PYTHON_OUT)/agent_pb2_grpc.py $(PYTHON_OUT)/agent_pb2.pyi
	rm -f $(NODE_OUT)/agent_pb.js $(NODE_OUT)/agent_grpc_pb.js
