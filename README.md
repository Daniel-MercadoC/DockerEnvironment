# DockerEnvironment
Workflow for working with docker to create Python environments inside containers (tested with Emacs)

These files contain the necessary information to build a docker container with the purpose of having an environment for developing Python computer vision and AI projects (separately). It has only been tested with Emacs, but the makefile can be run from any terminal so long as cmake is installed. The paths, however, are all normalized to Linux usage, so more modifications will be needed if running on Windows.

## Dependencies
Python dependencies included in the respective requirements.txt files, so they will be automatically installed when composing each docker image
- X11 for Linux (editable on all compose files)
- requirements.txt for CV:
  - numpy
  - scipy
  - scikit-image
  - opencv-python
  - pyyaml
- requirements.txt for AI:
  - numpy
  - pandas
  - matplotlib
  - scikit-learn

## Usage
The following files should be edited before composing either of the images:
- docker/compose/cv.yml
- docker/compose/ai.yml

  Where the lines to edit (in both) are:
  - <code>~/workspace:/workspace/code</code> change to: <code>...path/to/project/folder:/workspace/code</code> where all resources and code should be found
  - <code>/tmp/.X11-unix/:/tmp/.X11-unix</code> change depending on display drivers for any container to reference. This is required for any kind of display
  - <code>/dev/video0:dev/video0</code> change depending on display drivers for any container to reference. This is required for any kind of display

- Makefile
  Where the lines to edit are:
  ```makefile
  .PHONY: cv-run-test
  cv-run-test:
	  docker compose -f $(COMPOSE_FILE_CV) exec $(SERVICE_CV) python source/test.py

  .PHONY: ai-run-test
  ai-run-test:
	  docker compose -f $(COMPOSE_FILE_AI) exec $(SERVICE_AI) python source/test.py

  .PHONY: cv-run
  cv-run:
	  docker compose -f $(COMPOSE_FILE_CV) exec $(SERVICE_CV) python code/src/Test.py

  .PHONY: ai-run
  ai-run:
	  docker compose -f $(COMPOSE_FILE_AI) exec $(SERVICE_AI) python code/src/Test.py
  ```
  to:
  ```makefile
  .PHONY: cv-run-test
  cv-run-test:
	  docker compose -f $(COMPOSE_FILE_CV) exec $(SERVICE_CV) python ...path/inside/container/to/environment_test_file.py

  .PHONY: ai-run-test
  ai-run-test:
	  docker compose -f $(COMPOSE_FILE_AI) exec $(SERVICE_AI) python ...path/inside/container/to/environment_test_file.py

  .PHONY: cv-run
  cv-run:
	  docker compose -f $(COMPOSE_FILE_CV) exec $(SERVICE_CV) python ...path/inside/container/to/file_to_run.py

  .PHONY: ai-run
  ai-run:
	  docker compose -f $(COMPOSE_FILE_AI) exec $(SERVICE_AI) python ...path/inside/container/to/file_to_run.py
  ```
  and:
  

After that setup, both containers can now be used with the following:

#### Instructions
- Open a terminal in the same directory as the Makefile
- Run a command from the Makefile considering:
  - Structure to follow: <code>make <Makefile-command></code> (i.e.: <code>make cv-build</code>)
  - All commands run <code>docker compose -f <FILE_TO_COMPOSE></code>, after which they run a different set of commands by which they're named (i.e.: <code>make cv-build</code> will run <code>docker compose -f docker/compose/cv.yml build</code>). If unsure, the respective <code>build</code>, <code>up</code> and <code>shell</code> commands will run the container and bring up a shell within the terminal used which is running a minimal version of Linux called python:3.11-slim
  - If the names of any .yml files are changed, the Makefile will need to be edited.
  - When done with any activities, always end with the corresponding <code>down</code> command, as this setup exposes a path through ports leading to drivers! It's meant to be run locally, but leaving it open is unsafe.
- While running any docker containers, all files within the directory chosen in the .yml file are being reloaded live; so any changes to any file inside will be reflected inside the respective container. i.e.: If <code>...path/to/project/folder:/workspace/code</code> contains a test.py file, updates to said file outside the container will be found inside as well.
- Changes to any requirements, .yml or Dockerfile files will need a rebuild of its respective image
