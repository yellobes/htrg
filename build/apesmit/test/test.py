#-*- coding: utf-8 -*-

import apesmit
import StringIO


def _cmp_to_file(s, path):
    result=''.join(open('test/data/%s.xml'%path).readlines())
    return result==s.getvalue()
    

def test_simple():
    sm=apesmit.Sitemap()
    s=StringIO.StringIO()

    i=0
    for lastmod in (None, '2008-01-01'):
        for changefreq in (None, 'never'):
            for priority in (None, 0.6):
                sm.add('http://www.example.com/%i'%i,
                       lastmod=lastmod,
                       changefreq=changefreq,
                       priority=priority)
                i+=1
                
    sm.write(s)                       
    assert _cmp_to_file(s, 'simple')
           
    
    
def test_escape():    
    sm=apesmit.Sitemap()
    s=StringIO.StringIO()

    sm.add('http://example.com/&<>"\'')
    sm.write(s)                       
    assert _cmp_to_file(s, 'escape')


def test_defaults_lastmod():
    sm=apesmit.Sitemap(lastmod='24.12.2001')
    s=StringIO.StringIO()
    sm.add('http://example.com/')
    sm.write(s)
    assert _cmp_to_file(s, 'default_lm-1')

    sm=apesmit.Sitemap(lastmod='24.12.2001')
    s=StringIO.StringIO()
    sm.add('http://example.com/', lastmod='24.14.2002')
    sm.write(s)
    assert _cmp_to_file(s, 'default_lm-2')


def test_defaults_changefreq():
    sm=apesmit.Sitemap(changefreq='daily')
    s=StringIO.StringIO()
    sm.add('http://example.com/')
    sm.write(s)
    assert _cmp_to_file(s, 'default_cf-1')

    sm=apesmit.Sitemap(changefreq='weekly')
    s=StringIO.StringIO()
    sm.add('http://example.com/', changefreq='yearly')
    sm.write(s)
    assert _cmp_to_file(s, 'default_cf-2')

def test_defaults_priority():
    sm=apesmit.Sitemap(priority=0.9)
    s=StringIO.StringIO()
    sm.add('http://example.com/')
    sm.write(s)
    assert _cmp_to_file(s, 'default_pri-1')

    sm=apesmit.Sitemap(priority=0)
    s=StringIO.StringIO()
    sm.add('http://example.com/', priority=1)
    sm.write(s)
    assert _cmp_to_file(s, 'default_pri-2')



