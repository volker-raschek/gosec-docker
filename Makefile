# GOSEC_VERSION
# Only required to install a specifiy version
GOSEC_VERSION?=v2.9.6 # renovate: datasource=github-releases depName=gosec lookupName=securego/gosec versioning=semver

# CONTAINER_RUNTIME
# The CONTAINER_RUNTIME variable will be used to specified the path to a
# container runtime. This is needed to start and run a container image.
CONTAINER_RUNTIME?=$(shell which docker)

# HELM_IMAGE_REGISTRY_NAME
# Defines the name of the new container to be built using several variables.
HELM_IMAGE_REGISTRY_NAME:=docker.io
HELM_IMAGE_REGISTRY_USER:=volkerraschek

HELM_IMAGE_NAMESPACE?=${HELM_IMAGE_REGISTRY_USER}
HELM_IMAGE_NAME:=gosec
HELM_IMAGE_VERSION?=latest
HELM_IMAGE_FULLY_QUALIFIED=${HELM_IMAGE_REGISTRY_NAME}/${HELM_IMAGE_NAMESPACE}/${HELM_IMAGE_NAME}:${HELM_IMAGE_VERSION}
HELM_IMAGE_UNQUALIFIED=${HELM_IMAGE_NAMESPACE}/${HELM_IMAGE_NAME}:${HELM_IMAGE_VERSION}

# BUILD CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/build
container-image/build:
	${CONTAINER_RUNTIME} build \
		--build-arg GOSEC_VERSION=${GOSEC_VERSION} \
		--file Dockerfile \
		--no-cache \
		--pull \
		--tag ${HELM_IMAGE_FULLY_QUALIFIED} \
		--tag ${HELM_IMAGE_UNQUALIFIED} \
		.

# DELETE CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/delete
container-image/delete:
	- ${CONTAINER_RUNTIME} image rm ${HELM_IMAGE_FULLY_QUALIFIED} ${HELM_IMAGE_UNQUALIFIED}
	- ${CONTAINER_RUNTIME} image rm ${BASE_IMAGE_FULL}

# PUSH CONTAINER IMAGE
# ==============================================================================
PHONY+=container-image/push
container-image/push:
	echo ${HELM_IMAGE_REGISTRY_PASSWORD} | ${CONTAINER_RUNTIME} login ${HELM_IMAGE_REGISTRY_NAME} --username ${HELM_IMAGE_REGISTRY_USER} --password-stdin
	${CONTAINER_RUNTIME} push ${HELM_IMAGE_FULLY_QUALIFIED}

# PHONY
# ==============================================================================
# Declare the contents of the PHONY variable as phony.  We keep that information
# in a variable so we can use it in if_changed.
.PHONY: ${PHONY}