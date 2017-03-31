# To install eLSA on abel follow these steps while logged in on your abel account.  

module purge
module load python2/2.7.10.gnu
module load R/3.1.3.gnu
easy_install --user rpy2
wget https://bitbucket.org/charade/elsa/get/4b0d0350a0eb.zip
unzip 4b0d0350a0eb.zip
cd charade-elsa-4b0d0350a0eb
mkdir -p ~/Programs/elsa/lib/python2.7/site-packages/
export PYTHONPATH=$PYTHONPATH:~/Programs/elsa/lib/python2.7/site-packages/
python setup.py install --prefix=~/Programs/elsa
