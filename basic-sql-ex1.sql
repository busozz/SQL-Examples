Student (sid, name, birthPlace, did)          // ogrenci(ogrenci-no, adi, dogum-yeri, bolum-no)
Take (sid, cid, grade)                        // ders-al(ogrenci-no, ders-kodu, notu)
Course (cid, title, credits, did)             // ders(ders-kodu, adi, kredisi, bolum-no)
Department (did, name)                        // bolum(bolum-no, adi)
Teacher (tid, name, birthPlace, did)          // hoca(hoca-no, adi, dogum-yeri, bolum-no)
Teach (tid, cid)                              // ders-ver(hoca-no, ders-kodu)


1) ‘Ali KURT’ adlı hoca(lar)ın doğum yerlerini listeleme. (List the birth places of the teacher(s)
with the name ‘Ali KURT’.)

SELECT birthPlace 
FROM student
WHERE name=’Ali KURT’

/*---------------------------------*/

2)‘Veritabani’ adlı dersi alan öğrencilerin kayıtlarını listeleyiniz. (List the records of student taking
the course with the title: ‘Veritabanı’.)

SELECT s.*
FROM student s, take c, course c
WHERE s.sid=t.sid AND t.cid=c.cid AND c.title=’Veritabanı’

/*---------------------------------*/

3)Hiçbir öğrencinin almadığı derslerin kayıtlarını küme farkı işlemi kullanarak listeleyiniz. (List the
records of students not taking any courses using the set difference operator.)

SELECT s.*
FROM course s, (SELECT cid FROM course MINUS SELECT cid from take) x
WHERE s.cid=x.cid

/*---------------------------------*/

4) 3’ten fazla öğrencinin aldığı derslerin cid’si, dersi alan öğrenci sayısı, ve dersin not
ortalamalarını listeleyiniz. (List the cid, student count and average grade for courses taken by more than
3 students)

SELECT cid, COUNT(sid), AVG(grade)
FROM take t
GROUP BY cid
HAVING COUNT(sid) > 3

/*---------------------------------*/

5)‘Ali KURT’ adlı öğrenciyle aynı bölümdeki öğrencilerin kayıtlarını listeleyiniz. (List the records of
students who are in the same department as that of the student named ‘Ali KURT’)

SELECT s.*
FROM student s, student a
WHERE s.did=a.did AND a.name=’Ali KURT’

/*---------------------------------*/

6)Tüm dersleri veren hocaların kayıtlarını listeleyiniz. (List the records of teachers teaching all
courses)

SELECT *
FROM teacher
WHERE NOT EXISTS( (SELECT cid
FROM course)
EXCEPT
(SELECT cid
FROM teach
WHERE teach.tid=teacher.tid))


