from setuptools import setup, find_packages

with open('./requirements.txt') as reqs_txt:
    requirements = [line for line in reqs_txt]

setup(
    name="kz_pilot",
    version='0.0.1',
    description="A Python library for Kazoo auto provisisioning.",
    url='https://github.com/icehess/dockerfiles',
    project_urls={},
    packages=find_packages(exclude=["tests.*", "tests"]),
    entry_points={'console_scripts': ['kzpilot = kzpilot.__main__:main']},
    install_requires=requirements,
    classifiers=[
        'Environment :: Other Environment',
        'Intended Audience :: Developers',
        'Operating System :: OS Independent',
        'Programming Language :: Python :: 3.7',
        'Topic :: Software Development',
        'Topic :: Utilities',
        'License :: OSI Approved :: Apache Software License',
    ],
    maintainer='Hesaam F',
)
