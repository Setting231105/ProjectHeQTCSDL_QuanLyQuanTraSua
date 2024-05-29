USE QLQuanTraSua
GO

-- Tính doanh thu theo ngày
CREATE FUNCTION dbo.DoanhThuNgay(@Ngay INT, @Thang INT, @Nam INT)
RETURNS float
AS
BEGIN
	DECLARE @DoanhThu float = 0
	SELECT @DoanhThu = COALESCE(SUM(ThanhTien), 0)
	FROM HoaDonBan
	WHERE DAY(Ngay) = @Ngay AND MONTH(Ngay) = @Thang AND YEAR(Ngay) = @Nam
	RETURN @DoanhThu
END;
GO

-- Tính doanh thu theo tháng
CREATE FUNCTION [dbo].[DoanhThuThang](@Thang INT, @Nam INT) 
RETURNS float
BEGIN
	DECLARE @DoanhThu float = 0;
	SELECT @DoanhThu = COALESCE(SUM(ThanhTien), 0)
	FROM HoaDonBan
	WHERE MONTH(Ngay) = @Thang AND YEAR(Ngay) = @Nam
	RETURN @DoanhThu;
END;
GO

-- Tính doanh thu theo năm
CREATE FUNCTION [dbo].[DoanhThuNam](@Nam INT) 
RETURNS float
BEGIN
	DECLARE @DoanhThu float = 0;
	SELECT @DoanhThu = COALESCE(SUM(ThanhTien), 0)
	FROM HoaDonBan
	WHERE YEAR(Ngay) = @Nam
	RETURN @DoanhThu
END;
GO
------------------------------------------------------------------------------------------
-- KHÁCH HÀNG
--Tim kiem khach hang bang SDT---
CREATE or alter FUNCTION [dbo].[TimKiemKHBangSDT](@SDT nchar(11))
RETURNS nvarchar(50)
AS
BEGIN
DECLARE @TenKH nvarchar(50);
SELECT @TenKH = TenKH FROM KhachHang WHERE SDT = @SDT;
RETURN @TenKH;
END
GO
--Ham chay cau lenh tren--
select dbo.SearchTenKHBySDT('0385634423') , SDT, DiaChi  from dbo.KhachHang WHERE SDT = '0385634423'
GO

--Tim kiem khach hang bang Ten khách hàng--
CREATE or alter FUNCTION [dbo].[TimKiemKHBangTen](@TenKH nvarchar(20))
RETURNS nvarchar(50)
AS
BEGIN
DECLARE @SDT nchar(11);
SELECT @SDT = SDT FROM KhachHang WHERE TenKH = @TenKH;
RETURN @SDT;
END
GO
--Hàm chạy câu lệnh trên
select TenKH, dbo.SearchTenKHByTen('Ý'), DiaChi  from dbo.KhachHang where SDT=dbo.SearchTenKHByTen('Ý')
GO
------------------------------------------------------------------------------------------
-- HÓA ĐƠN ỨNG DỤNG
-- Tính tổng tiền hóa đơn ung dung
CREATE FUNCTION func_TinhThanhTien (@MaHDUD nchar(10))
RETURNS INT
AS
BEGIN
    DECLARE @ThanhTien INT
    
    SELECT @ThanhTien = SUM(TongTien)
    FROM ChiTietHoaDonUngDung
    WHERE MaHD_UD = @MaHDUD
    
    RETURN @ThanhTien
END
GO
------------------------------------------------------------------------------------------
-- SẢN PHẨM
-- Tìm kiếm sản phẩm
CREATE FUNCTION [dbo].[func_TimSanPham] (@string NVARCHAR(50))
RETURNS @IngreList TABLE (MaSP nchar(10), TenSP nvarchar(50), DonGia float, TinhTrang nchar(10),MaLoaiSP nchar(10))
AS
BEGIN
 INSERT INTO @IngreList
 SELECT *
 FROM dbo.SanPham
 WHERE CONCAT(MaSP, TenSP, DonGia, TinhTrang, MaLoaiSP) LIKE N'%' + @string + '%'
 RETURN
END
GO
------------------------------------------------------------------------------------------
-- NGUYÊN LIỆU
-- Tìm kiếm nguyên liệu
CREATE FUNCTION [dbo].[func_TimNguyenLieu] (@string NVARCHAR(50))
RETURNS @IngreList TABLE (MaNL VARCHAR(10), TenNL NVARCHAR(50), MaNCC 
VARCHAR(10), SoLuong INT, DonVi NVARCHAR(10))
AS
BEGIN
 INSERT INTO @IngreList
 SELECT *
 FROM dbo.NguyenLieu
 WHERE CONCAT(MaNL, TenNL, MaNCC, DonVi) LIKE N'%' + @string + '%'
 RETURN
END