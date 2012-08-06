#!/usr/bin/env python
#-*- coding: utf-8-*-
#
# ApeSmit - a very simple Python module to create XML sitemaps
#
# Copyright (C) 2008 Florian Diesch <devel@florian-diesch.de>
#
# Homepage: http://www.florian-diesch.de/software/apesmit
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

import glob

import distribute_setup
distribute_setup.use_setuptools()


from setup_helpers import (
    description, find_doctests, get_version, long_description, require_python)
from setuptools import setup, find_packages


require_python(0x20600f0)
__version__ = '0.01'


setup(
    name='apesmit',
    version=__version__,
    packages=find_packages(),
    include_package_data=True,
    maintainer='Florian Diesch',
    maintainer_email='devel@florian-diesch.de',
    author = "Florian Diesch",
    author_email = "devel@florian-diesch.de",    
    description='simple Python module to create XML sitemaps',
    long_description=long_description(
        'README.txt',
        ),
    license='GPLv2',
    url='http://www.florian-diesch.de/software/apesmit/',
    download_url='http://www.florian-diesch.de/software/apesmit/',
    keywords = "xml, sitemap, web, website", 
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: GNU General Public License (GPL)',
        'Natural Language :: English',
        'Natural Language :: German',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Topic :: Internet :: WWW/HTTP',
        'Topic :: Software Development :: Libraries :: Python Modules'
        ],
    )
