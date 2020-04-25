from	setuptools	import	setup,	find_packages
setup(
				name='Project 1',
				version='1.0',
				author='Saeid Hosseinipoor',
				authour_email='saied@ou.edu',
				packages=find_packages(exclude=('tests', 'docs'))
)