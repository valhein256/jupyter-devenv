# Run Jupyter Service on Docker Container

## Build
Build docker image for jupyter server. 

    $ make build
    or
    $ make build-jupyter

## Launch
Launch docker container to run jupyter service

    $ make launch-jupyter

## Python Libs
see [jupyter/pyproject.toml].
To update python libs:

    $ make jupyter-libs-update

### Install other python package
Run following command to launch jupyter-dev

    # login jupyter-dev
    $ make jupyter-dev
    # install py-package
    (jupyter-dev):/opt/app# poetry add <py-package>

It would update the poetry files: [jupyter/pyproject.toml] and [poetry.lock].
Run following command to rebuild docker image with new for <py-package> jupyter server. 

    $ make build

[jupyter/pyproject.toml]: https://github.com/valhein256/jupyter-devenv/blob/master/jupyter/pyproject.toml
[poetry.lock]: https://github.com/valhein256/jupyter-devenv/blob/master/jupyter/poetry.lock
