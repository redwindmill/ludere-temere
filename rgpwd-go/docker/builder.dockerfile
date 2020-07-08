#NOTE: when bumping version, run make af-go-vendor to update go.mod
FROM golang:1-buster
LABEL red.version.golang ${GOLANG_VERSION}

RUN apt-get update && apt-get install -y --no-install-recommends \
	clang \
	dos2unix

WORKDIR /mnt/src
VOLUME [ "/mnt/src", "/mnt/out" ]
