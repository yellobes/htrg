#! /usr/bin/python2.7

# Peter Novotnak::Flexion INC, 2012


from apesmit import Sitemap
from sys     import stdin, argv

path = argv[1]

sm = Sitemap( changefreq='weekly' )

for line in stdin:
    sm.add( str(line).strip(),
            lastmod='today')


out=open(str(path)+'/sitemap.xml', 'w')
sm.write(out)
out.close()




