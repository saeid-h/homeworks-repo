from setuptools import setup, find_packages
setup(
	 name='normanpd',
	 version='2.0',
	 author='Saeid Hosseinipoor',
	 authour_email='saied@ou.edu',
	 packages=find_packages(exclude=('tests', 'docs'))
)