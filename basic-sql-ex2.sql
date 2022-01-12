sarki (sarkino, ad, tur, sure, bestecino, yazarno)
sarkici (sarkicino, ad, tur, dogumTarih, dogumYer)
album (albumno, ad, yil, fiyat, sarkicino, stokAdet)
albumdekiSarki  (albumno, sarkino, sira)
besteci (bestecino, ad, tur)
sozyazari (yazarno, ad)


1)Türü ‘arabesk’ ve süresi 3 dakikadan uzun olan şarkıların adlarını tekrarsız olarak ve alfanümerik sırada
artan sırada listeleme işlemi.

SELECT DISTINCT ad
FROM sarki
WHERE tur = 'arabesk' AND sure > 3
ORDER BY ad ASC

/*--------------------------------------------*/

2)Doğum yeri ‘Ankara’ olan ya da albüme sahip olan şarkıcıların kayıtlarını listeleme işlemi.

WITH ankaraliYadaAlbumeSahip AS
(SELECT sarkicino
FROM karkici
WHERE dogumYer='Ankara')
UNION
(SELECT sarkicino
FROM album)
SELECT DISTINCT ad
FROM sarkici s, ankaraliYadaAlbumeSahip x
WHERE s.sarkicino = x.sarkicino

/*--------------------------------------------*/

3)Şarkıcılar ve albümlerini şarkıcının adı, albümünün adı, album yılı şeklinde listeleyen sorguyu WHERE
içinde sarkici.sarkicino=album.sarkicino koşuluyla, FROM içinde NATURAL JOIN cümleciğiyle, WHERE
içinde IN ile, =SOME ile ve EXISTS kullanarak 5 farklı şekilde yazma işlemi.

a)SELECT s.ad, a.ad, a.yil
  FROM sarkici s, album a
  WHERE s.sarkicino = a.sarkicino

b)SELECT s.ad, a.ad, a.yil
  FROM sarkici s NATURAL JOIN album a

c)SELECT s.ad
  FROM sarkici s
  WHERE s.sarkicino IN (SELECT sarkicino FROM album)

d)SELECT s.ad
  FROM sarkici s
  WHERE s.sarkicino = SOME (SELECT sarkicino FROM album)

e)SELECT s.ad
  FROM sarkici s
  WHERE EXISTS(SELECT * FROM album a WHERE s.sarkicino=a.sarkicino)

/*--------------------------------------------*/

4)Hiç albümü olmayan şarkıcıların kayıtlarını küme farkı (MINUS/EXCEPT), NOT IN, != ALL ve NOT EXISTS
kullanarak 4 farklı şekilde yazma işlemi.

a)SELECT *
  FROM sarkici s, (SELECT sarkicino FROM sarkici EXCEPT SELECT sarkicino FROM album) albumsuzler
  WHERE s.sarkicino=albumsuzler.sarkicino

b)SELECT *
  FROM sarkici s
  WHERE sarkicino NOT IN (SELECT * FROM album)

c)SELECT *
  FROM sarkici s
  WHERE sarkicino != ALL (SELECT * FROM album)

d)SELECT *
  FROM sarkici s
  WHERE NOT EXISTS (SELECT * FROM album WHERE album.sarkicino=s.sarkicino)

/*--------------------------------------------*/

5)Albümlerin numaraları, adı, şarkıcısının adı, fiyatı, içindeki şarkıların sayısı ve süre
uzunlukları toplamını listeleme işlemi.

WITH x AS
  SELECT albumno, COUNT(a.sarkino) sayisi, SUM(s.sure) suresi
  FROM albumdekiSarki a, sarki s
  WHERE a.sarkino=s.sarkino
GROUP BY a.albumno
SELECT x.*, s.ad, a.fiyat
FROM x, album a, sarkici s
WHERE x.albumno=a.albumno AND a.sarkcino=s.sarkicino

/*--------------------------------------------*/

6)‘arabesk’ türündeki bestecilerden 5 adetten çok şarkı besteleyenlerin besteci adı
ve kaç şarkı bestelediklerini listeleme işlemi.

WITH X AS
  SELECT b.bestecino, COUNT(sarkino) sayi
  FROM besteci b, sarki s
  WHERE b.bestecino=s.bestecino AND b.tur='arabesk'
GROUP BY b.bestecino
HAVING COUNT(sarkino) > 5
SELECT x.*, b.ad
FROM x, besteci b
WHERE x.bestecino=b.bestecino

/*--------------------------------------------*/

7)En fazla albüme sahip şarkıcıların kayıtlarını listeleme işlemi.

WITH albumSayilari AS
SELECT sarkicino, COUNT(albumno) albumsayisi
From album
GROUP BY sarkicino),
enCokAlbum as
SELET MAX(albumsayisi) encok
FROM albumSayilari
SELECT s.*
FROM sarkici s, albumSayilari a, enCokAlbum e
WHERE s.sarkicino=a.sarkicino and a.albumsayisi=e.encok

/*--------------------------------------------*/

8)‘arabesk’ türündeki tüm şarkıların yazarlığını yapmış yazarların kayıtlarını listeleme işlemi.

SELECT *
FROM sozyazari y
WHERE NOT EXISTS( (SELECT sarkino FROM sarki WHERE tur='arabesk')
MINUS
(SELECT sarkino FROM sarki s WHERE s.yazarno=y.yazarno) )

/*--------------------------------------------*/

9)En çok şarkı sözü yazmış olan yazarların yazarno’larını aggregate fonksiyon veya group by kullanmadan bulma işlemi.

WITH

x AS SELECT yazarno, COUNT(sarkino) sayi
FROM sarki s
GROUP BY yazarno

y AS SELECT x1.sayi, x1.yazarno
FROM x x1, x x2
WHERE x1.sayi < x2.sayi
(SELECT yazarno FROM sozyazari)
MINUS
(SELECT yazarno FROM y)




