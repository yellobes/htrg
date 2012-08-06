# Peter Novotnak::Flexion INC, 2012


from apesmit import Sitemap
from sys     import stdin



sm = Sitemap( changefreq='weekly' )

for line in stdin:
    sm.add( line,
            lastmod='today')


out=open('sitemap.xml', 'w')
sm.write(out)
out.close()




