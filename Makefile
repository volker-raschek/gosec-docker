# GOSEC_VERSION
# Only required to install a specifiy version
GOSEC_VERSION?=v2.22.0 # renovate: datasource=github-releases depName=securego/gosec

# CONTAINER_RUNTIME
# The CONTAINER_RUNTIME variable will be used to specified the path to a
# container runtime. This is needed to start and run a container image.
CONTAINER_RUNTIME?=$(shell which podman)

# GOSEC_IMAGE_REGISTRY_NAME
# Defines the name of the new container to be built using several variables.
GOSEC_IMAGE_REGISTRY_NAME:=git.cryptic.systems
GOSEC_IMAGE_REGISTRY_USER:=volker.raschek

GOSEC_IMAGE_NAMESPACE?=${GOSEC_IMAGE_REGISTRY_USER}
GOSEC_IMAGE_NAME:=gosec
GOSEC_IMAGE_VERSION?=latest
GOSEC_IMAGE_FULLY_QUALIFIED=${GOSEC_IMAGE_REGISTRY_NAME}/${GOSEC_IMAGE_NAMESPACE}/${GOSEC_IMAGE_NAME}:${GOSEC_IMAGE_VERSION}
GOSEC_IMAGE_UNQUALIFIED=${GOSEC_IMAGE_NAMESPACE}/${GOSEC_IMAGE_NAME}:${GOSEC_IMAGE_VERSION}

# BUILD CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/build
container-image/build:
	${CONTAINER_RUNTIME} build \
		--build-arg GOSEC_VERSION=${GOSEC_VERSION} \
		--file Dockerfile \
		--no-cache \
		--pull \
		--tag ${GOSEC_IMAGE_FULLY_QUALIFIED} \
		--tag ${GOSEC_IMAGE_UNQUALIFIED} \
		.

# DELETE CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/delete
container-image/delete:
	- ${CONTAINER_RUNTIME} image rm ${GOSEC_IMAGE_FULLY_QUALIFIED} ${GOSEC_IMAGE_UNQUALIFIED}
	- ${CONTAINER_RUNTIME} image rm ${BASE_IMAGE_FULL}

# PUSH CONTAINER IMAGE
# ==============================================================================
PHONY+=container-image/push
container-image/push:
	echo ${GOSEC_IMAGE_REGISTRY_PASSWORD} | ${CONTAINER_RUNTIME} login ${GOSEC_IMAGE_REGISTRY_NAME} --username ${GOSEC_IMAGE_REGISTRY_USER} --password-stdin
	${CONTAINER_RUNTIME} push ${GOSEC_IMAGE_FULLY_QUALIFIED}

# PHONY
# ==============================================================================
# Declare the contents of the PHONY variable as phony.  We keep that information
# in a variable so we can use it in if_changed.
.PHONY: ${PHONY}