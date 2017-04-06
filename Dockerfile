# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# ubuntu16.04 with jupyterhub notebook
# GPU devel and cuDNN version - cuda 8.0 dev & cuDNN 5.0

FROM citcailearning/minimal_notebook:ubuntu16.04 

MAINTAINER Jupyter Project <jupyter@googlegroups.com>

USER root

# libav-tools for matplotlib anim
RUN apt-get update && \
    apt-get install -y --no-install-recommends libav-tools && \
    apt-get install -y libpng-dev && \
    apt-get install -y libfreetype6-dev &&\
    apt-get install -y libx11-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN ln -s /usr/include/freetype2/ft2build.h /usr/include/

USER $NB_USER

# Install Python 3 packages
# Remove pyqt and qt pulled in for matplotlib since we're only ever going to
# use notebook-friendly backends in these images
#RUN conda install --quiet --yes \
#    'ipywidgets=5.2*' \
#    'pandas=0.18*' \
#    'numexpr=2.5*' \
#    'matplotlib=1.5*' \
#    'scipy=0.17*' \
#    'seaborn=0.7*' \
#    'scikit-learn=0.17*' \
#    'scikit-image=0.11*' \
#    'sympy=1.0*' \
#    'cython=0.23*' \
#    'patsy=0.4*' \
#    'statsmodels=0.6*' \
#    'cloudpickle=0.1*' \
#    'dill=0.2*' \
#    'numba=0.23*' \
#    'bokeh=0.11*' \
#    'sqlalchemy=1.0*' \
#    'hdf5=1.8.17' \
#    'h5py=2.6*' && \
#    conda remove --quiet --yes --force qt pyqt && \
#    conda clean -tipsy
RUN conda install --quiet --yes 'llvmlite'
RUN conda install --quiet --yes 'hdf5=1.8.17'
#RUN /opt/conda/bin/pip install ipywidgets==5.2
RUN /opt/conda/bin/pip install pandas==0.18
RUN /opt/conda/bin/pip install numexpr==2.5
RUN /opt/conda/bin/pip install matplotlib==1.5
RUN /opt/conda/bin/pip install scipy==0.17
RUN /opt/conda/bin/pip install seaborn==0.7
RUN /opt/conda/bin/pip install scikit-learn==0.17
RUN /opt/conda/bin/pip install scikit-image==0.11.3
RUN /opt/conda/bin/pip install sympy==1.0
RUN /opt/conda/bin/pip install cython==0.23
RUN /opt/conda/bin/pip install patsy==0.4
RUN /opt/conda/bin/pip install statsmodels==0.6
RUN /opt/conda/bin/pip install cloudpickle==0.1
RUN /opt/conda/bin/pip install dill==0.2
RUN /opt/conda/bin/pip install numba==0.23
RUN /opt/conda/bin/pip install bokeh==0.11
RUN /opt/conda/bin/pip install sqlalchemy==1.0
RUN /opt/conda/bin/pip install h5py==2.6



# Activate ipywidgets extension in the environment that runs the notebook server
#RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix

# Install Python 2 packages
# Remove pyqt and qt pulled in for matplotlib since we're only ever going to
# use notebook-friendly backends in these images
#RUN conda create --quiet --yes -p $CONDA_DIR/envs/python2 python=2.7 \
#    'ipython=4.2*' \
#    'ipywidgets=5.2*' \
#    'pandas=0.18*' \
#    'numexpr=2.5*' \
#    'matplotlib=1.5*' \
#    'scipy=0.17*' \
#    'seaborn=0.7*' \
#    'scikit-learn=0.17*' \
#    'scikit-image=0.11*' \
#    'sympy=1.0*' \
#    'cython=0.23*' \
#    'patsy=0.4*' \
#    'statsmodels=0.6*' \
#    'cloudpickle=0.1*' \
#    'dill=0.2*' \
#    'numba=0.23*' \
#    'bokeh=0.11*' \
#    'hdf5=1.8.17' \
#    'h5py=2.6*' \
#    'sqlalchemy=1.0*' \
#    'pyzmq' && \
#    conda remove -n python2 --quiet --yes --force qt pyqt && \
#    conda clean -tipsy
# Add shortcuts to distinguish pip for python2 and python3 envs
#RUN ln -s $CONDA_DIR/envs/python2/bin/pip $CONDA_DIR/bin/pip2 && \
#    ln -s $CONDA_DIR/bin/pip $CONDA_DIR/bin/pip3

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
#RUN MPLBACKEND=Agg $CONDA_DIR/envs/python2/bin/python -c "import matplotlib.pyplot"

# Configure ipython kernel to use matplotlib inline backend by default
RUN mkdir -p $HOME/.ipython/profile_default/startup
COPY mplimporthook.py $HOME/.ipython/profile_default/startup/

#USER root

# Install Python 2 kernel spec globally to avoid permission problems when NB_UID
# switching at runtime.
#RUN $CONDA_DIR/envs/python2/bin/python -m ipykernel install

USER $NB_USER
