USE QLQuanTraSua
GO
-- Nhập vào bảng Vị trí công việc
Insert into ViTriCongViec Values ('VT01', N'Quản lý', 50000)
Insert into ViTriCongViec Values ('VT02', N'Pha chế', 30000)
Insert into ViTriCongViec Values ('VT03', N'Thu ngân', 20000)
Insert into ViTriCongViec Values ('VT04', N'Phục vụ', 30000)

-- Nhập vào bảng Loại nhân viên
Insert into LoaiNhanVien Values (01, 'Part-time', 30000)
Insert into LoaiNhanVien Values (02, 'Full-time', 50000)

-- Nhập vào bảng Nhân viên
Insert into Nhanvien Values ('NV01', N'Linh', '1999-08-07', N'Nữ', N'111 Võ Văn Ngân', '0938194729', '2', 'vt01', '2022-10-23')
Insert into Nhanvien Values ('NV02', N'Khang', '2001-11-20', N'Nam', N'10 Lê Văn Việt', '0372937192', '2', 'vt02', '2022-10-23')
Insert into Nhanvien Values ('NV03', N'Chi', '2001-11-20', N'Nữ', N'45 Lê Văn Thọ', '0374529123', '1', 'vt02', '2022-12-10')
Insert into Nhanvien Values ('NV04', N'Phong', '2000-02-10', N'Nam', N'30 Phạm Văn Đồng', '0904621346', '1', 'vt03', '2023-01-23')

--Nhập vào bảng Nhà cung cấp
Insert into NhaCungCap Values ('NCC01', 'ABC', NULL, '0904182475')
Insert into NhaCungCap Values ('NCC02', 'DEF', NULL, '0939561728')

-- Nhập vào bảng Hóa đơn nhập
Insert into HoaDonNhap Values ('HDN0001', '2023-03-08', 450000, 'NCC01')
Insert into HoaDonNhap Values ('HDN0002', '2023-03-08', 300000, 'NCC02')
Insert into HoaDonNhap Values ('HDN0003', '2023-03-09', 350000 , 'NCC01')





-- Nhập vào bảng Loại sản phẩm
Insert into LoaiSanPham Values ('LNV01', N'Trà Đài Loan')
Insert into LoaiSanPham Values ('LNV02', N'Trà Chanh')
Insert into LoaiSanPham Values ('LNV03', N'Trà Latte')
Insert into LoaiSanPham Values ('LNV04', N'Trà Sữa')
Insert into LoaiSanPham Values ('LNV05', N'Topping')

-- Nhập vào bảng Sản phẩm
Insert into SanPham Values ('SP01', N'Hồng trà Đài Loan', 20000, N'Hết hàng', 'LNV01')
Insert into SanPham Values ('SP02', N'Hồng trà vải thiều', 25000, N'Hết hàng', 'LNV01')
Insert into SanPham Values ('SP03', N'Trà xanh hoa nhài ', 25000, N'Hết hàng', 'LNV01')
Insert into SanPham Values ('SP04', N'Hồng trà chanh Đài Loan', 25000, N'Hết hàng', 'LNV02')
Insert into SanPham Values ('SP05', N'Hồng trà chanh vải thiều', 25000, N'Hết hàng', 'LNV02')
Insert into SanPham Values ('SP06', N'Trà xanh chanh', 20000, N'Hết hàng', 'LNV02')
Insert into SanPham Values ('SP07', N'Hồng trà latte Đài Loan', 30000, N'Hết hàng', 'LNV03')
Insert into SanPham Values ('SP08', N'Hồng trà latte vải thiều', 30000, N'Hết hàng', 'LNV03')
Insert into SanPham Values ('SP09', N'Trà xanh latte', 30000, N'Hết hàng', 'LNV03')
Insert into SanPham Values ('SP10', N'Trà sữa Đài Loan', 25000, N'Hết hàng', 'LNV04')
Insert into SanPham Values ('SP11', N'Trà sữa vải thiều', 25000, N'Hết hàng', 'LNV04')
Insert into SanPham Values ('SP12', N'Trà xanh sữa', 25000, N'Hết hàng', 'LNV04')
Insert into SanPham Values ('SP13', N'Trân châu đường đen', 7000, N'Hết hàng', 'LNV05')
Insert into SanPham Values ('SP14', N'Trân châu trắng', 7000, N'Hết hàng', 'LNV05')
Insert into SanPham Values ('SP15', N'Thạch đào', 6000, N'Hết hàng', 'LNV05')
Insert into SanPham Values ('SP16', N'Thạch vải', 6000, N'Hết hàng', 'LNV05')

-- Nhập vào bảng Ứng dụng
Insert into UngDung Values ('UD01', N'Shopee Food', 25)
Insert into UngDung Values ('UD02', N'Grab Food', 25)
Insert into UngDung Values ('UD03', N'Be Food', 25)
Insert into UngDung Values ('UD04', N'Go Food', 25)









-- Nhập vào bảng Ca làm việc
Insert into CaLamViec Values ('C01', '2023-10-24', '7 giờ', '11 giờ')
Insert into CaLamViec Values ('C02', '2023-10-24', '11 giờ', '15 giờ')
Insert into CaLamViec Values ('C03', '2023-10-24', '15 giờ', '19 giờ')
Insert into CaLamViec Values ('C04', '2023-10-24', '19 giờ', '23 giờ')

-- Nhập vào bảng Bảng phân ca
Insert into BangPhanCa Values ('C01', 'NV01', '2023-10-24')
Insert into BangPhanCa Values ('C01', 'NV02', '2023-10-24')
Insert into BangPhanCa Values ('C02', 'NV01', '2023-10-24')
Insert into BangPhanCa Values ('C02', 'NV02', '2023-10-24')
--=================================================================
-- Nhập vào bảng Nguyên liệu
Insert into NguyenLieu Values ('NL01', 'Trà Xanh', 'NCC01', 10, 'kg')
Insert into NguyenLieu Values ('NL02', 'Sữa', 'NCC01', 8, 'lit')
Insert into NguyenLieu Values ('NL03', 'Đường', 'NCC01', 12, 'kg')
Insert into NguyenLieu Values ('NL04', 'Vải Thiều', 'NCC01', 5, 'kg')
Insert into NguyenLieu Values ('NL05', 'Hồng Trà', 'NCC01', 7, 'kg')

-- Nhập vào bảng Chế biến
Insert into CheBien Values('SP01', 'NL05', 1, 'kg')
Insert into CheBien Values('SP01', 'NL03', 1.5, 'kg')
Insert into CheBien Values('SP02', 'NL05', 1, 'kg')
Insert into CheBien Values('SP02', 'NL03', 1.5, 'kg')


-- Nhập vào bảng Khách Hàng
Insert into KhachHang Values('0938637721', 'Tâm', '484 Lê Văn Chí')
Insert into KhachHang Values('0385634423', 'Lan', '1 Mai Chí Thọ')
Insert into KhachHang Values('0728574886', 'Trân', '4 Quang Trung')

-- Nhập vào bảng Hóa đơn bán
Insert into HoaDonBan Values('HDB1000', '11-02-2023', '0938637721', 'NV04', 40000)

-- Nhập vào bảng Chi tiết đơn bán
Insert into ChiTietDonBan Values('HDB1000', 'SP01', 2, 20000, 40000)

-- Nhập vào bảng Chi tiết đơn nhập
Insert into ChiTietDonNhap Values('HDN0001', 'NL05', 9000, 5, 'kg', 45000)

-- Nhập vào bảng Hóa đơn ứng dụng
Insert into HoaDonUngDung Values('UD_001', '11-03-2023', '0938637721', 'UD01', 'NV04', 40000) 

-- Nhập vào bảng Chi tiết hóa đơn ứng dụng
Insert into ChiTietHoaDonUngDung Values('UD_001', 'SP02', 2, 25000, 40000)





