
-- Lấy ngày sinh nhật trong khoảng [a, b] (ko quan tâm năm) để chúc mừng sinh nhật
-- dùng with để đặt biến trong postgresql

with daterange (startDate, endDate) as (
	values (to_date('28022021', 'DDMMYYYY'), to_date('01032021', 'DDMMYYYY'))
)
SELECT "TenGV", "NgaySinh",
       AGE(startDate, "NgaySinh"),
			 AGE(endDate, "NgaySinh"),
				1 = date_part('year', AGE(endDate, "NgaySinh")) - date_part('year', AGE(startDate, "NgaySinh")),
	date_part('year', AGE(startDate, "NgaySinh"))	> date_part('year', AGE(startDate - 1, "NgaySinh"))
from giaovien, daterange

-- nhận xét: ngày sinh nhật nghĩa là thêm 1 tuổi vì vậy trừ 2 ngày để xác định có thêm 1 tuổi
-- nếu bằng 1 nghĩa đã thêm 1 tuổi
-- tuy nhiên khi thực hiện phép trừ nếu ngày bắt đầu rơi đúng vào ngày sinh thì sẽ trừ đi bằng 0,
-- vì vậy cần giảm ngày bắt đầu đi 1 để xác định có thêm 1 tuổi hay ko

where 1 = date_part('year', AGE(endDate, "NgaySinh")) - date_part('year', AGE(startDate, "NgaySinh")) 
or date_part('year', AGE(startDate, "NgaySinh")) > date_part('year', AGE(startDate - 1, "NgaySinh"));
