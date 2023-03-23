
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


-- question: Nhu cầu lọc giá trị ko tồn tại trong bảng (user input)
-- ví dụ: bảng nhanvien có các ID: 1 2 3 4 5 đã được insert. Yêu cầu lấy các id ko có trong bảng album. Giá trị id được user nhập vào

-- Kết quả: id 7, 8 là các giá trị sẽ được hiển thị

-- Giải quyết: sử dụng except hoặc not in hoặc not exists. Đối với user input sử dụng union all, values, regexp_split_to_table
-- C1: sử dụng union all
-- C2: sử dụng values
-- C3: regexp_split_to_table nhưng cần convert lại nếu id là kiểu int
-- ref: https://stackoverflow.com/questions/9410157/select-what-element-of-collection-is-not-in-a-column-of-table

-- C1:
select id_nhan_vien from 
(
	select 1 as id_nhan_vien
	union all
	select 2
	union all
	select 7
	union all
	select 8
) x
except 
select id_nhan_vien from nhanvien a;

--C2:
select id_nhan_vien from 
(
	values (1),(2),(3),(7), (8)
) x(id_nhan_vien)
except 
select id_nhan_vien from nhanvien a;
	

-- question: Nhu cầu lọc giá trị không tồn tại trong bảng nguồn 
-- ví dụ: bảng nhanvien có các ID: 1 2 3 4 5 đã được insert. Bảng phòng ban có id 1 2 3 4 5 đã được insert.
-- Với id_nhan_vien 1 2 thuộc phòng ban 1, 
--	id_nhan_vien 3 4 thuộc phòng ban 2, 
--	id_nhan_vien 5   thuộc phòng ban 3

-- Yêu cầu lấy các id phòng ban ko có trong bảng nhân viên

-- kết quả: id_phong_ban 4, 5 là các giá trị sẽ được hiển thị vì chưa có nhân viên

-- Giải quyết: sử dụng except hoặc not in hoặc not exists. Đối với user input sử dụng union all, values, regexp_split_to_table
-- C1: sử dụng except
-- C2: sử dụng not exists
-- C3: sử dụng not in
-- C1:
select id_phong_ban from phongban
except 
select id_phong_ban from nhanvien;

-- question: Kiểm tra 2 bảng có cùng bộ dữ liệu