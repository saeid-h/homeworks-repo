from setuptools import setup, find_packages
setup(
	 name='extracredit',
	 version='1.0',
	 author='Saeid Hosseinipoor',
	 authour_email='saied@ou.edu',
	 packages=find_packages(exclude=('tests', 'docs')),
     setup_requires=['pytest-runner'],
     tests_require=['pytest']
)
