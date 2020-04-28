FROM jupyterhub/jupyterhub:1.2
#RUN which python3     # /usr/bin/python3
#RUN python3 --version # Python 3.6.9

# Add useful tools (wget for the health check)
RUN apt-get update && apt-get install -y vim wget

# Install spawner
RUN pip3 install --upgrade pip
RUN pip3 install dockerspawner==0.11.1 # most recent on 20200422, on pypi

# Logo
COPY ./logo.png ./archive/
COPY ./dkrz_favicon.ico ./archive/favicon.ico

# Useful for reference:
# RUN pwd # /srv/jupyterhub
COPY ./Dockerfile ./archive/
COPY ./docker-compose.yml ./archive/
COPY ./jupyterhub_config.py ./archive/
COPY ./healthcheck_jupyterhub.sh ./archive/
COPY ./ADAPTED_start.sh ./archive/
# ADAPTED_start.sh is for running as uid 33
RUN echo `date` > ./archive/now.txt
RUN ls -lpah ./archive

# Install out-of-the-box Dummyauthenticator from pip
RUN pip3 install jupyterhub-dummyauthenticator
# Use this like this:
# c.JupyterHub.authenticator_class = 'jupyterhub.auth.DummyAuthenticator'
# c.DummyAuthenticator.password = "change-me"

# Install custom VREAuthenticator

# From local files:
COPY ./auth_package jupyterhub-vreauthenticator/
RUN cd ./jupyterhub-vreauthenticator && python3 setup.py install && cd ..
# From github: # TODO
#RUN git clone https://github.com/merretbuurman/jupyterhub-webdavauthenticator.git
#RUN cd jupyterhub-webdavauthenticator && python setup.py install && cd ..

# This is only to check if it built correctly:
RUN python3 -c "import vreauthenticator"

# docker build -t jupyterhub_vre:20200428 .
# docker build -t registry-sdc.argo.grnet.gr/jupyterhub_vre:20200428 .
# docker push registry-sdc.argo.grnet.gr/jupyterhub_vre:20200428