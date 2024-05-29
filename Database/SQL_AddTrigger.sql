USE QLQuanTraSua
GO

-- BẢNG HÓA ĐƠN BÁN
-- Trigger bắt lỗi khi thêm, cập nhật
CREATE TRIGGER trg_CheckHoaDonBan
ON HoaDonBan
FOR INSERT, UPDATE
AS
BEGIN
    -- Check MaHDB
    IF EXISTS (SELECT * FROM inserted WHERE TRIM(MaHDB) = '')
    BEGIN
        RAISERROR('Mã hóa đơn không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Check Ngay
    IF EXISTS (SELECT * FROM inserted WHERE DATEDIFF(year, Ngay, GETDATE()) < 0)
    BEGIN
        RAISERROR('Ngày hóa đơn không thể là trong tương lai', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Check SDT
    IF NOT EXISTS (SELECT * FROM KhachHang WHERE SDT = (SELECT SDT FROM inserted))
    BEGIN
        RAISERROR('Số điện thoại không tồn tại', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

	IF EXISTS (SELECT * FROM inserted WHERE LEN(SDT) <> 10)
    BEGIN
        RAISERROR('Số điện thoại phải có đúng 10 ký tự', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Check MaNV
    IF EXISTS (SELECT * FROM inserted WHERE TRIM(MaNV) = '')
    BEGIN
        RAISERROR('Mã nhân viên không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    IF NOT EXISTS (SELECT * FROM NhanVien WHERE MaNV = (SELECT MaNV FROM inserted))
    BEGIN
        RAISERROR('Mã nhân viên không tồn tại', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Check ThanhTien
    IF EXISTS (SELECT * FROM inserted WHERE ThanhTien < 0)
    BEGIN
        RAISERROR('Giá trị Thành Tiền không hợp lệ', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END
GO
---------------------------------------------------------------------
-- BẢNG CHI TIẾT HÓA ĐƠN BÁN
-- Trigger bắt lỗi khi thêm, cập nhật
CREATE TRIGGER trg_CheckChiTietDonBan
ON ChiTietDonBan
FOR INSERT, UPDATE
AS
BEGIN
    -- Check MaHDB
    IF EXISTS (SELECT * FROM inserted WHERE TRIM(MaHDB) = '')
    BEGIN
        RAISERROR('Mã hóa đơn không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    IF NOT EXISTS (SELECT * FROM HoaDonBan WHERE MaHDB = (SELECT MaHDB FROM inserted))
    BEGIN
        RAISERROR('Mã hóa đơn không tồn tại', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Check MaSP
    IF EXISTS (SELECT * FROM inserted WHERE TRIM(MaSP) = '')
    BEGIN
        RAISERROR('Mã sản phẩm không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    IF NOT EXISTS (SELECT * FROM SanPham WHERE MaSP = (SELECT MaSP FROM inserted))
    BEGIN
        RAISERROR('Mã sản phẩm không tồn tại', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Check SoLuong
    IF EXISTS (SELECT * FROM inserted WHERE SoLuong <= 0)
    BEGIN
        RAISERROR('Số lượng phải lớn hơn 0', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Check DonGia
    IF EXISTS (SELECT * FROM inserted WHERE DonGia < 0)
    BEGIN
        RAISERROR('Đơn giá không được âm', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Check TongTien
    IF EXISTS (SELECT * FROM inserted WHERE TongTien < 0)
    BEGIN
        RAISERROR('Tổng tiền không được âm', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END
GO

-- Kiểm tra xem nguyên liệu trong kho còn đủ để đáp ứng số lượng sản phẩm khách hàng yêu cầu hay không
CREATE TRIGGER TG_SPHetHang
ON ChiTietDonBan
AFTER INSERT
AS
BEGIN
	Declare @newMaSP nchar(10), @newSL int, @MaNLMin nchar(10), @SLMin int, @LieuLuongCan float
	Select @newMaSP = ne.MaSP, @newSL = ne.SoLuong
	From inserted ne

	Select @SLMin = min(NguyenLieu.SoLuong)
	From NguyenLieu, CheBien
	Where NguyenLieu.MaNL = CheBien.MaNL
		and CheBien.MaSP = @newMaSP
	Select TOP 1 @MaNLMin = NguyenLieu.MaNL, @LieuLuongCan = CheBien.LieuLuong
	From NguyenLieu, CheBien
	Where NguyenLieu.MaNL = CheBien.MaNL
		and CheBien.MaSP = @newMaSP
		and NguyenLieu.SoLuong = @SLMin

	IF (@newSL*@LieuLuongCan - @SLMin*1000 > 0)
	BEGIN
		UPDATE SanPham
		SET TinhTrang = 'Hết hàng'
		WHERE MaSP = @newMaSP
		ROLLBACK
	END
END
GO
---------------------------------------------------------------------
-- BẢNG NHÀ CUNG CẤP
-- Trigger bắt lỗi khi thêm, cập nhật
CREATE TRIGGER trg_CheckNhaCungCap
ON NhaCungCap
FOR INSERT, UPDATE
AS
BEGIN
    -- Check MaNCC
    IF EXISTS (SELECT * FROM inserted WHERE TRIM(MaNCC) = '')
    BEGIN
        RAISERROR('Mã nhà cung cấp không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Check TenNCC
    IF EXISTS (SELECT * FROM inserted WHERE TRIM(TenNCC) = '')
    BEGIN
        RAISERROR('Tên nhà cung cấp không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Check SDT
    IF EXISTS (SELECT * FROM inserted WHERE LEN(SDT) <> 10)
    BEGIN
        RAISERROR('Số điện thoại nhà cung cấp phải có đúng 10 ký tự', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END
GO
---------------------------------------------------------------------
-- BẢNG HÓA ĐƠN NHẬP
-- Trigger bắt lỗi khi thêm, cập nhật
CREATE TRIGGER trg_CheckHoaDonNhap
ON HoaDonNhap
FOR INSERT, UPDATE
AS
BEGIN
    -- Check MaHDN
    IF EXISTS (SELECT * FROM inserted WHERE TRIM(MaHDN) = '')
    BEGIN
        RAISERROR('Mã hóa đơn nhập không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Check NgayNhap
    IF EXISTS (SELECT * FROM inserted WHERE DATEDIFF(DAY, NgayNhap, GETDATE()) < 0)
    BEGIN
        RAISERROR('Ngày nhập không được lớn hơn ngày hiện tại', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Check TriGiaDonNhap
    IF EXISTS (SELECT * FROM inserted WHERE TriGiaDonNhap < 0)
    BEGIN
        RAISERROR('Trị giá đơn nhập không được âm', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Check MaNCC
    IF NOT EXISTS (SELECT * FROM NhaCungCap WHERE MaNCC = (SELECT MaNCC FROM inserted))
    BEGIN
        RAISERROR('Mã nhà cung cấp không tồn tại', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END
GO
---------------------------------------------------------------------
-- BẢNG CHI TIẾT HÓA ĐƠN NHẬP
-- Trigger bắt lỗi khi thêm, cập nhật
CREATE TRIGGER trg_CheckChiTietDonNhap
ON ChiTietDonNhap
FOR INSERT, UPDATE
AS
BEGIN
    -- Check MaHDN
    IF EXISTS (SELECT * FROM inserted WHERE TRIM(MaHDN) = '')
    BEGIN
        RAISERROR('Mã hóa đơn nhập không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    IF NOT EXISTS (SELECT * FROM HoaDonNhap WHERE MaHDN = (SELECT MaHDN FROM inserted))
    BEGIN
        RAISERROR('Mã hóa đơn nhập không tồn tại', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Check MaNL
    IF EXISTS (SELECT * FROM inserted WHERE TRIM(MaNL) = '')
    BEGIN
        RAISERROR('Mã nguyên liệu không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    IF NOT EXISTS (SELECT * FROM NguyenLieu WHERE MaNL = (SELECT MaNL FROM inserted))
    BEGIN
        RAISERROR('Mã nguyên liệu không tồn tại', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Check DonGia
    IF EXISTS (SELECT * FROM inserted WHERE DonGia < 0)
    BEGIN
        RAISERROR('Đơn giá không được âm', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Check SoLuong
    IF EXISTS (SELECT * FROM inserted WHERE SoLuong <= 0)
    BEGIN
        RAISERROR('Số lượng phải lớn hơn 0', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Check DonVi
    IF EXISTS (SELECT * FROM inserted WHERE TRIM(DonVi) = '')
    BEGIN
        RAISERROR('Đơn vị không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Check TongTien
    IF EXISTS (SELECT * FROM inserted WHERE TongTien < 0)
    BEGIN
        RAISERROR('Tổng tiền không được âm', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END
GO
------------------------------------------------------------------------------------------
-- NHÂN VIÊN
-- Trigger bắt lỗi khi thêm hoặc sửa thông tin nhân viên
CREATE TRIGGER trg_CheckNhanVien
ON NhanVien
FOR INSERT, UPDATE
AS
BEGIN
	-- check MaNV
	IF EXISTS (SELECT * FROM inserted WHERE TRIM(MaNV) = ' ')
	BEGIN
		RAISERROR('Mã nhân viên không được để trống', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END
	IF NOT EXISTS (SELECT * FROM NhanVien WHERE MaNV IN (SELECT MaNV FROM
	inserted))
	BEGIN
		RAISERROR('Mã nhân viên đã tồn tại', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END
	-- check ho ten nhan vien
	IF EXISTS (SELECT * FROM inserted WHERE TRIM(TenNV) = '' )
		BEGIN
		RAISERROR('Tên nhân viên không được để trống', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END
	IF EXISTS (SELECT 1 FROM inserted i INNER JOIN NhanVien n ON i.MaNV != n.MaNV
	AND TRIM(i.TenNV) = TRIM(n.TenNV))
	BEGIN
		RAISERROR('Tên nhân viên đã tồn tại', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END
	-- check ngay sinh
	IF EXISTS (SELECT * FROM inserted WHERE
	datediff(year,inserted.NgaySinh,getdate())<(18))
	BEGIN
		RAISERROR ('Nhân viên phải trên 18 tuổi', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END
	-- check dia chi
	IF EXISTS (SELECT * FROM inserted WHERE TRIM(DiaChi) = '' )
	BEGIN
		RAISERROR('Địa chỉ không được để trống', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	 END
	-- check so dien thoai
	IF EXISTS (SELECT * FROM inserted WHERE TRIM(SDT) = '' )
	BEGIN
		RAISERROR('Số điện thoại không được để trống', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END
	IF NOT EXISTS (SELECT * FROM inserted WHERE len(TRIM(SDT)) = (10))
	BEGIN
		RAISERROR('Số điện thoại gồm 10 chữ số', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END
	IF EXISTS (SELECT 1 FROM inserted i INNER JOIN NhanVien n ON i.MaNV != n.MaNV
	AND TRIM(i.SDT) = TRIM(n.SDT))
	BEGIN
		RAISERROR('Số điện thoại đã tồn tại', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END
	-- check ngay tuyen dung
	IF NOT EXISTS (SELECT * FROM inserted WHERE
	(datediff(day,[NgayTuyenDung],getdate())>=(0)))
	BEGIN
		RAISERROR ('Ngày tuyển dụng không thể là trong tương lai', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END
END
GO
------------------------------------------------------------------------------------------
-- KHÁCH HÀNG
--trigger bat loi khi them khach hang--
CREATE TRIGGER trg_InsertNewKhachHang
ON KhachHang
FOR INSERT, UPDATE
AS
BEGIN
-- check SDT
IF EXISTS (SELECT * FROM inserted WHERE TRIM(SDT) = ' ')
BEGIN
RAISERROR('S? di?n tho?i khách hàng không du?c d? tr?ng', 16, 1)
ROLLBACK TRANSACTION
RETURN
END
IF NOT EXISTS (SELECT * FROM KhachHang WHERE SDT IN (SELECT SDT FROM
inserted))
BEGIN
RAISERROR('SDT dã t?n t?i', 16, 1)
ROLLBACK TRANSACTION
RETURN
END
END;

------------------------------------------------------------------------------------------
-- ỨNG DỤNG
--trigger bat loi khi them ung dung moi--
CREATE TRIGGER trg_ThemUngDungMoi
ON UngDung
FOR INSERT, UPDATE
AS
BEGIN
-- check MaUD
IF EXISTS (SELECT * FROM inserted WHERE TRIM(MaUD) = ' ')
BEGIN
RAISERROR('Ma Ung dung khong duoc trung', 16, 1)
ROLLBACK TRANSACTION
RETURN
END
IF NOT EXISTS (SELECT * FROM UngDung WHERE MaUD IN (SELECT MaUD FROM
inserted))
BEGIN
RAISERROR('Ma ung dung dã t?n t?i', 16, 1)
ROLLBACK TRANSACTION
RETURN
END
-- check ten ung dung
IF EXISTS (SELECT * FROM inserted WHERE TRIM(TenUD) = ' ')
BEGIN
RAISERROR('Tên ung dung không du?c d? tr?ng', 16, 1)
ROLLBACK TRANSACTION
RETURN
END
END;

------------------------------------------------------------------------------------------
-- LOẠI SẢN PHẨM
-- Trigger bắt lỗi khi thêm loại sản phẩm mới
CREATE TRIGGER trg_ThemLoaiSanPham
ON LoaiSanPham
FOR INSERT, UPDATE
AS
BEGIN
 -- check MaLoaiSP
IF EXISTS (SELECT * FROM inserted WHERE TRIM(MaLoaiSP) = ' ')
BEGIN
 RAISERROR('Mã loại sản phẩm không được để trống', 16, 1)
 ROLLBACK TRANSACTION
 RETURN
 END
IF NOT EXISTS (SELECT * FROM LoaiSanPham WHERE MaLoaiSP IN (SELECT MaLoaiSP FROM
inserted))
BEGIN
 RAISERROR('Mã loại sản phẩm đã tồn tại', 16, 1)
 ROLLBACK TRANSACTION
 RETURN
 END
-- check TenLoaiSP
IF EXISTS (SELECT * FROM inserted WHERE TRIM(TenLoaiSP) = ' ')
BEGIN
 RAISERROR('Tên loại sản phẩm không được để trống', 16, 1)
 ROLLBACK TRANSACTION
 RETURN
 END
END
GO
------------------------------------------------------------------------------------------
-- SẢN PHẨM
-- Trigger bắt lỗi trùng tên khi thêm và sửa sản phẩm
CREATE TRIGGER trg_TrungTenSanPham
ON dbo.SanPham
AFTER INSERT, UPDATE
AS
BEGIN
 -- Kiểm tra tên sản phẩm vừa thêm có bị trùng lặp
 IF EXISTS (
 SELECT *
 FROM inserted i
 WHERE EXISTS (
 SELECT *
 FROM dbo.SanPham sp
 WHERE sp.TenSP = i.TenSP AND sp.MaSP <> i.MaSP
 )
 )
 BEGIN
 -- Nếu trùng thì rollback
 RAISERROR ('Tên sản phẩm bị trùng', 16, 1)
 ROLLBACK;
 END
END
GO