USE QLQuanTraSua
GO

-- BẢNG HÓA ĐƠN BÁN
-- Thêm hóa đơn bán
CREATE PROCEDURE [dbo].[proc_ThemHoaDonBan]
	@MaHDB nchar(10),
	@Ngay date,
	@SDT nchar(11),
	@MaNV nchar(10),
	@ThanhTien int
AS
BEGIN
	INSERT INTO HoaDonBan (MaHDB, Ngay, SDT, MaNV, ThanhTien)
	VALUES (@MaHDB, @Ngay, @SDT, @MaNV, @ThanhTien)
END
GO

-- Cập nhật hóa đơn bán
CREATE PROCEDURE [dbo].[proc_SuaHoaDonBan]
	@MaHDB nchar(10),
	@Ngay date,
	@SDT nchar(11),
	@MaNV nchar(10),
	@ThanhTien int
AS
BEGIN
	BEGIN TRY
		-- Sửa thông tin hóa đơn bán
		UPDATE dbo.HoaDonBan 
		SET Ngay = @Ngay, SDT = @SDT, MaNV = @MaNV, ThanhTien = @ThanhTien
		WHERE MaHDB = @MaHDB
	END TRY
	BEGIN CATCH
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = N'Lỗi' + ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

-- Xóa hóa đơn bán
CREATE PROCEDURE [dbo].[proc_XoaHoaDonBan]
@MaHDB nchar(10)
AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			-- Xoá các chi tiết hóa đơn bán theo @MaHDB trong bảng ChiTietDonBan
			DELETE FROM dbo.ChiTietDonBan WHERE ChiTietDonBan.MaHDB = @MaHDB
			-- Xoá hóa đơn bán theo @MaHDB trong bảng HoaDonBan
			DELETE FROM dbo.HoaDonBan WHERE HoaDonBan.MaHDB = @MaHDB
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK
			DECLARE @err NVARCHAR(MAX)
			SELECT @err = N'Lỗi' + ERROR_MESSAGE()
			RAISERROR(@err, 16, 1)
		END CATCH
END
GO
------------------------------------------------------------------
-- BẢNG CHI TIẾT ĐƠN BÁN
-- Thêm chi tiết đơn bán
CREATE PROCEDURE [dbo].[proc_ThemChiTietDonBan]
	@MaHDB nchar(10),
	@MaSP nchar(10),
	@SoLuong int,
	@DonGia float,
	@TongTien float
AS
BEGIN
	INSERT INTO ChiTietDonBan (MaHDB, MaSP, SoLuong, DonGia, TongTien)
	VALUES (@MaHDB, @MaSP, @SoLuong, @DonGia, @TongTien)
END
GO

-- Sửa chi tiết đơn bán
CREATE PROCEDURE [dbo].[proc_SuaChiTietDonBan]
	@MaHDB nchar(10),
	@MaSP nchar(10),
	@SoLuong int,
	@DonGia float,
	@TongTien float
AS
BEGIN
	BEGIN TRY
		-- Sửa thông tin chi tiết đơn bán
		UPDATE dbo.ChiTietDonBan 
		SET SoLuong = @SoLuong, DonGia = @DonGia, TongTien = @TongTien
		WHERE MaHDB = @MaHDB AND MaSP = @MaSP
	END TRY
	BEGIN CATCH
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = N'Lỗi' + ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

-- Xóa chi tiết đơn bán
CREATE PROCEDURE [dbo].[proc_XoaChiTietDonBan]
	@MaHDB nchar(10),
	@MaSP nchar(10)
AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			-- Xoá chi tiết đơn bán theo @MaHDB và @MaSP trong bảng ChiTietDonBan
			DELETE FROM dbo.ChiTietDonBan WHERE ChiTietDonBan.MaHDB = @MaHDB AND ChiTietDonBan.MaSP = @MaSP
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK
			DECLARE @err NVARCHAR(MAX)
			SELECT @err = N'Lỗi' + ERROR_MESSAGE()
			RAISERROR(@err, 16, 1)
		END CATCH
END
GO

-- Tính tổng tiền bên chi tiết hóa đơn sau đó cập nhật qua hóa đơn bán
CREATE PROCEDURE [dbo].[proc_TinhTongTienHDB]
    @MaHDB nchar(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE HoaDonBan
    SET ThanhTien = (SELECT SUM(TongTien)
                     FROM ChiTietDonBan
                     WHERE ChiTietDonBan.MaHDB = HoaDonBan.MaHDB
                     GROUP BY MaHDB)
    WHERE MaHDB = @MaHDB
      AND EXISTS (SELECT 1
                  FROM ChiTietDonBan
                  WHERE ChiTietDonBan.MaHDB = HoaDonBan.MaHDB
                  GROUP BY MaHDB);
END;
GO
------------------------------------------------------------------
-- BẢNG NHÀ CUNG CẤP
-- Thêm nhà cung cấp
CREATE PROCEDURE [dbo].[proc_ThemNhaCungCap]
	@MaNCC nchar(10),
	@TenNCC nvarchar(50),
	@DiaChi nchar(100),
	@SDT nchar(10)
AS
BEGIN
	INSERT INTO NhaCungCap(MaNCC, TenNCC, DiaChi, SDT)
	VALUES (@MaNCC, @TenNCC, @DiaChi, @SDT)
END
GO

-- Cập nhật nhà cung cấp
CREATE PROCEDURE [dbo].[proc_SuaNhaCungCap]
	@MaNCC nchar(10),
	@TenNCC nvarchar(50),
	@DiaChi nchar(100),
	@SDT nchar(10)
AS
BEGIN
	BEGIN TRY
		-- Sửa thông tin nhà cung cấp
		UPDATE dbo.NhaCungCap 
		SET TenNCC = @TenNCC, DiaChi = @DiaChi, SDT = @SDT
		WHERE MaNCC = @MaNCC
	END TRY
	BEGIN CATCH
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = N'Lỗi' + ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

-- Xóa nhà cung cấp
CREATE PROCEDURE [dbo].[proc_XoaNhaCungCap]
	@MaNCC nchar(10)
AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			-- Xoá nhà cung cấp theo @MaNCC trong bảng NhaCungCap
			DELETE FROM dbo.NhaCungCap WHERE NhaCungCap.MaNCC = @MaNCC
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK
			DECLARE @err NVARCHAR(MAX)
			SELECT @err = N'Lỗi' + ERROR_MESSAGE()
			RAISERROR(@err, 16, 1)
		END CATCH
END
GO
------------------------------------------------------------------
-- BẢNG HÓA ĐƠN NHẬP
-- Xuất hóa đơn nhập
CREATE PROCEDURE [dbo].[proc_ThemHoaDonNhap]
	@MaHDN nchar(10),
	@NgayNhap date,
	@TriGiaDonNhap float,
	@MaNCC nchar(10)
AS
BEGIN
	INSERT INTO HoaDonNhap (MaHDN, NgayNhap, TriGiaDonNhap, MaNCC)
	VALUES (@MaHDN, @NgayNhap, @TriGiaDonNhap, @MaNCC)
END
GO

-- Cập nhật hóa đơn nhập
CREATE PROCEDURE [dbo].[proc_SuaHoaDonNhap]
	@MaHDN nchar(10),
	@NgayNhap date,
	@TriGiaDonNhap float,
	@MaNCC nchar(10)
AS
BEGIN
	BEGIN TRY
		-- Sửa thông tin hóa đơn nhập
		UPDATE dbo.HoaDonNhap 
		SET NgayNhap = @NgayNhap, TriGiaDonNhap = @TriGiaDonNhap, MaNCC = @MaNCC
		WHERE MaHDN = @MaHDN
	END TRY
	BEGIN CATCH
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = N'Lỗi' + ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

-- Xóa hóa đơn nhập
CREATE PROCEDURE [dbo].[proc_XoaHoaDonNhap]
@MaHDN nchar(10)
AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			-- Xoá các chi tiết hóa đơn nhập theo @MaHDN trong bảng ChiTietDonNhap
			DELETE FROM dbo.ChiTietDonNhap WHERE ChiTietDonNhap.MaHDN = @MaHDN
			-- Xoá hóa đơn nhập theo @MaHDN trong bảng HoaDonNhap
			DELETE FROM dbo.HoaDonNhap WHERE HoaDonNhap.MaHDN = @MaHDN
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK
			DECLARE @err NVARCHAR(MAX)
			SELECT @err = N'Lỗi' + ERROR_MESSAGE()
			RAISERROR(@err, 16, 1)
		END CATCH
END
GO
------------------------------------------------------------------
-- BẢNG CHI TIẾT ĐƠN NHẬP
-- Thêm chi tiết đơn nhập
CREATE PROCEDURE [dbo].[proc_ThemChiTietDonNhap]
	@MaHDN nchar(10),
	@MaNL nchar(10),
	@DonGia float,
	@SoLuong int,
	@DonVi nchar(10),
	@TongTien float
AS
BEGIN
	INSERT INTO ChiTietDonNhap (MaHDN, MaNL, DonGia, SoLuong, DonVi, TongTien)
	VALUES (@MaHDN, @MaNL, @DonGia, @SoLuong, @DonVi, @TongTien)
END
GO

-- Cập nhật chi tiết đơn nhập
CREATE PROCEDURE [dbo].[proc_SuaChiTietDonNhap]
	@MaHDN nchar(10),
	@MaNL nchar(10),
	@DonGia float,
	@SoLuong int,
	@DonVi nchar(10),
	@TongTien float
AS
BEGIN
	BEGIN TRY
		-- Sửa thông tin chi tiết đơn nhập
		UPDATE dbo.ChiTietDonNhap 
		SET DonGia = @DonGia, SoLuong = @SoLuong, DonVi = @DonVi, TongTien = @TongTien
		WHERE MaHDN = @MaHDN AND MaNL = @MaNL
	END TRY
	BEGIN CATCH
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = N'Lỗi' + ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

-- Xóa chi tiết đơn nhập
CREATE PROCEDURE [dbo].[proc_XoaChiTietDonNhap]
	@MaHDN nchar(10),
	@MaNL nchar(10)
AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			-- Xoá chi tiết đơn nhập theo @MaHDN và @MaNL trong bảng ChiTietDonNhap
			DELETE FROM dbo.ChiTietDonNhap WHERE ChiTietDonNhap.MaHDN = @MaHDN AND ChiTietDonNhap.MaNL = @MaNL
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK
			DECLARE @err NVARCHAR(MAX)
			SELECT @err = N'Lỗi' + ERROR_MESSAGE()
			RAISERROR(@err, 16, 1)
		END CATCH
END
GO

-- Tính tổng tiền bên chi tiết hóa đơn sau đó cập nhật qua hóa đơn nhập
CREATE PROCEDURE [dbo].[proc_TinhTongTienHDN]
    @MaHDN nchar(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE HoaDonNhap
    SET TriGiaDonNhap = (SELECT SUM(TongTien)
                     FROM ChiTietDonNhap
                     WHERE ChiTietDonNhap.MaHDN = HoaDonNhap.MaHDN
                     GROUP BY MaHDN)
    WHERE MaHDN = @MaHDN
      AND EXISTS (SELECT 1
                  FROM ChiTietDonNhap
                  WHERE ChiTietDonNhap.MaHDN = HoaDonNhap.MaHDN
                  GROUP BY MaHDN);
END;
GO
------------------------------------------------------------------
--BẢNG PHÂN CA
--Thêm phân ca cho nhân viên
CREATE PROCEDURE [dbo].[proc_ThemBangPhanCa]
    @MaCa nchar(10),
    @MaNV nchar(10),
    @Ngay date
AS
BEGIN
    -- Thêm bản ghi vào BangPhanCa
    INSERT INTO BangPhanCa (MaCa, MaNV, Ngay)
    VALUES (@MaCa, @MaNV, @Ngay)
END
GO


-- Cập nhật bảng phân ca làm việc của nhân viên, giữ nguyên mã ca và ngày
CREATE PROCEDURE [dbo].[proc_SuaBangPhanCa]
    @MaCa nchar(10),
    @MaNV nchar(10),
    @Ngay date
AS
BEGIN
	BEGIN TRY
		-- Cập nhật thông bảng phân ca
		UPDATE BangPhanCa
		SET MaNV = @MaNV
		WHERE MaCa = @MaCa AND Ngay = @Ngay
	END TRY
	BEGIN CATCH
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = N'Lỗi' + ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
	END
GO

--Xóa ca làm của nhân viên
CREATE PROC [dbo].[proc_XoaBangPhanCa]
	@MaNV nchar(10),
	@MaCa nchar(10),
	@Ngay nchar(10)
AS
BEGIN
	BEGIN TRY
	DELETE FROM BangPhanCa
	WHERE MaNV = @MaNV and
			MaCa = @MaCa and
			Ngay = @Ngay
	END TRY
	BEGIN CATCH
	DECLARE @err NVARCHAR(MAX)
	SELECT @err = N'Lỗi ' + ERROR_MESSAGE()
	RAISERROR(@err, 16, 1)
	END CATCH
END
GO
------------------------------------------------------------------
--BẢNG VỊ TRÍ CÔNG VIỆC
--Thêm vị trí công việc
CREATE PROCEDURE [dbo].[proc_ThemViTriCongViec]
	@MaViTri nchar(10),
	@TenViTri nvarchar(50),
	@PhuCapLuong float
AS
BEGIN
		-- Thêm vị trí công việc
		INSERT INTO ViTriCongViec (MaViTri, TenViTri, PhuCapLuong)
		VALUES (@MaViTri, @TenViTri, @PhuCapLuong)
END
GO

--Cập nhật vị trí công việc
CREATE PROCEDURE [dbo].[proc_SuaViTriCongViec]
	@MaViTri nchar(10),
	@TenViTri nvarchar(50),
	@PhuCapLuong float
AS
BEGIN
	BEGIN TRY
		-- Cập nhật thông tin vị trí công việc
		UPDATE ViTriCongViec
		SET TenViTri = @TenViTri, PhuCapLuong = @PhuCapLuong
		WHERE MaViTri = @MaViTri
	END TRY
	BEGIN CATCH
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = N'Lỗi' + ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

--Xóa vị trí công việc
CREATE PROCEDURE [dbo].[proc_XoaViTriCongViec]
	@MaViTri nchar(10)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			-- Xoá vị trí công việc theo @MaViTri trong bảng NhanVien
			DELETE FROM dbo.NhanVien WHERE NhanVien.MaViTri = @MaViTri
			-- Xóa vị trí công việc theo @MaViTri trong bảng ViTriCongViec
			DELETE FROM dbo.ViTriCongViec WHERE ViTriCongViec.MaViTri = @MaViTri
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = N'Lỗi' + ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO
------------------------------------------------------------------
-- BẢNG CA LÀM VIỆC
-- Lấy ngày theo mã ca
CREATE PROCEDURE [dbo].[LayNgayTheoMaCa_CaLamViec]
    @MaCa nchar(10),
    @Ngay date OUTPUT
AS
BEGIN
    BEGIN TRY
        SELECT TOP 1 @Ngay = Ngay
        FROM CaLamViec
        WHERE MaCa = @MaCa
    END TRY
    BEGIN CATCH
        SET @Ngay = NULL
    END CATCH
END

GO

-- Thêm ca làm việc
CREATE PROCEDURE [dbo].[proc_ThemCaLamViec]
	@MaCa nchar(10),
	@Ngay date,
	@GioBatDau nchar(10),
	@GioKetThuc nchar(10)
AS
BEGIN
	-- Thêm ca làm việc
	INSERT INTO CaLamViec (MaCa, Ngay, GioBatDau, GioKetThuc)
	VALUES (@MaCa, @Ngay, @GioBatDau, @GioKetThuc)
END
GO

-- Chạy câu lệnh trên
--exec dbo.proc_ThemCaLamViec @MaCa='05', @Ngay='10-11-2022', @GioBatDau='23', @GioKetThuc='3'

GO
-- Cập nhật ca làm việc
CREATE PROCEDURE [dbo].[proc_SuaCaLamViec]
    @MaCa nchar(10),
    @Ngay date,
    @GioBatDau nchar(10),
    @GioKetThuc nchar(10)
AS
BEGIN
    BEGIN TRY
        -- Cập nhật thông tin ca làm việc
        UPDATE dbo.CaLamViec
        SET GioBatDau = @GioBatDau, GioKetThuc = @GioKetThuc
        WHERE MaCa = @MaCa AND Ngay = @Ngay

        -- Kiểm tra xem có bản ghi nào bị ảnh hưởng không
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Không tìm thấy ca làm việc để cập nhật.', 16, 1)
        END
    END TRY
    BEGIN CATCH
        RAISERROR('Lỗi trong quá trình cập nhật.', 16, 1)
    END CATCH
END

GO

-- Xóa ca làm việc
CREATE PROCEDURE [dbo].[proc_XoaCaLamViec]
    @MaCa nchar(10),
    @Ngay date
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

        -- Xoá ca làm việc theo @MaCa và @Ngay trong bảng CaLamViec
        DELETE FROM dbo.CaLamViec WHERE CaLamViec.MaCa = @MaCa AND CaLamViec.Ngay = @Ngay

        -- Xóa ca làm việc theo @MaCa và @Ngay trong BangPhanCa
        DELETE FROM dbo.BangPhanCa WHERE BangPhanCa.MaCa = @MaCa AND BangPhanCa.Ngay = @Ngay

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        RAISERROR('Lỗi trong quá trình xóa.', 16, 1)
    END CATCH
END
GO
------------------------------------------------------------------
-- BẢNG LOẠI NHÂN VIÊN
-- Thêm loại nhân viên
CREATE PROCEDURE [dbo].[proc_ThemLoaiNhanVien]
	@MaLoaiNV nchar(10),
	@TenLoaiNV nvarchar(50),
	@LuongCB float
AS
BEGIN
	-- Thêm loại nhân viên
	INSERT INTO LoaiNhanVien (MaLoaiNV, TenLoaiNV, LuongCB)
	VALUES (@MaLoaiNV, @TenLoaiNV, @LuongCB)
END
GO

-- Cập nhật loại nhân viên
CREATE PROCEDURE [dbo].[proc_SuaLoaiNhanVien]
	@MaLoaiNV nchar(10),
	@TenLoaiNV nvarchar(50),
	@LuongCB float
AS
BEGIN
	BEGIN TRY
		-- Cập nhật thông tin loại nhân viên
		UPDATE LoaiNhanVien
		SET TenLoaiNV = @TenLoaiNV, LuongCB = @LuongCB
		WHERE MaLoaiNV = @MaLoaiNV
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = N'Lỗi' + ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

-- Xóa loại nhân viên
CREATE PROCEDURE [dbo].[proc_XoaLoaiNhanVien]
	@MaLoaiNV nchar(10)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		-- Xoá loại nhân viên theo @MaLoaiNV trong bảng LoaiNhanVien
		DELETE FROM dbo.LoaiNhanVien WHERE LoaiNhanVien.MaLoaiNV = @MaLoaiNV
		-- Xóa loại nhân viên theo @MaLoaiNV trong bảng NhanVien
		DELETE FROM dbo.NhanVien WHERE NhanVien.MaLoaiNV = @MaLoaiNV
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = N'Lỗi' + ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO
------------------------------------------------------------------
-- BẢNG NHÂN VIÊN
-- Thêm nhân viên
CREATE PROCEDURE [dbo].[proc_ThemNhanVien]
	@MaNV nchar(10),
	@TenNV nvarchar(10),
	@NgaySinh date,
	@GioiTinh nvarchar(3),
	@DiaChi nvarchar(100),
	@SDT nchar(11),
	@MaLoaiNV nchar(10),
	@MaViTri nchar(10),
	@NgayTuyenDung date
AS
BEGIN
	-- Thêm nhân viên
	INSERT INTO NhanVien (MaNV, TenNV, NgaySinh, GioiTinh, DiaChi, SDT, MaLoaiNV, MaViTri, NgayTuyenDung)
	VALUES (@MaNV, @TenNV, @NgaySinh, @GioiTinh, @DiaChi, @SDT, @MaLoaiNV, @MaViTri, @NgayTuyenDung)
END
GO

-- Cập nhật nhân viên
CREATE PROCEDURE [dbo].[proc_SuaNhanVien]
	@MaNV nchar(10),
	@TenNV nvarchar(10),
	@NgaySinh date,
	@GioiTinh nvarchar(3),
	@DiaChi nvarchar(100),
	@SDT nchar(11),
	@MaLoaiNV nchar(10),
	@MaViTri nchar(10),
	@NgayTuyenDung date
AS
BEGIN
	BEGIN TRY
		-- Cập nhật thông tin nhân viên
		UPDATE NhanVien
		SET TenNV = @TenNV, NgaySinh = @NgaySinh, GioiTinh = @GioiTinh, DiaChi = @DiaChi, SDT = @SDT,
			MaLoaiNV = @MaLoaiNV, MaViTri = @MaViTri, NgayTuyenDung = @NgayTuyenDung
		WHERE MaNV = @MaNV
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = N'Lỗi' + ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

-- Xóa nhân viên
CREATE PROCEDURE [dbo].[proc_XoaNhanVien]
	@MaNV nchar(10)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		-- Xoá nhân viên theo @MaNV trong bảng NhanVien
		DELETE FROM dbo.NhanVien WHERE NhanVien.MaNV = @MaNV
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = N'Lỗi' + ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO
------------------------------------------------------------------------------------------
-- KHÁCH HÀNG
--Ham xoa khach hang---
CREATE PROCEDURE [dbo].[proc_XoaKhachHang]
@SDT nchar(11)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRANSACTION;
BEGIN TRY
DELETE FROM KhachHang WHERE SDT = @SDT;
END TRY
BEGIN CATCH
DECLARE @err NVARCHAR(MAX)
SELECT @err = N'Lỗi ' + ERROR_MESSAGE()
RAISERROR(@err, 16, 1)
ROLLBACK TRANSACTION;
THROW;
END CATCH
COMMIT TRANSACTION;
END

--Chay thuc thi chuong trinh--
exec dbo.proc_XoaKhachHang @SDT='0553634423'
GO

-- Sua thong tin khach hang
CREATE PROCEDURE [dbo].[proc_SuaNhaKhachHang]
	@SDT nchar(11),
	@TenKH nvarchar(50),
	@DiaChi nchar(100)
AS
BEGIN
	BEGIN TRY
		-- Sửa thông tin hóa đơn bán
		UPDATE dbo.KhachHang 
		SET SDT = @SDT, TenKH = @TenKH, DiaChi = @DiaChi
		WHERE SDT = @SDT
	END TRY
	BEGIN CATCH
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = N'Lỗi' + ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

--Them Khach Hang moi---
CREATE or alter PROCEDURE [dbo].[proc_ThemKhachHang]
@SDT nchar(11),
@TenKH nvarchar(50),
@DiaChi nvarchar(100)
AS
BEGIN
IF EXISTS (SELECT 1 FROM KhachHang WHERE SDT = @SDT)
BEGIN
RETURN;
END
INSERT INTO KhachHang (SDT, TenKH, DiaChi)
VALUES (@SDT, @TenKH, @DiaChi)
END

-- chay cau lenh tren--
exec dbo.InsertNewKhachHang @SDT='0553634423', @TenKH=N'Ý', @DiaChi=N'232 Tr??ng ??nh'
GO
------------------------------------------------------------------------------------------
-- ỨNG DỤNG
--Them ung dung moi--
CREATE or alter PROCEDURE [dbo].[proc_ThemUngDung]
@MaUD nchar(10),
@TenUD nvarchar(50),
@ChietKhau int
AS
BEGIN
IF EXISTS (SELECT 1 FROM UngDung WHERE MaUD = @MaUD)
BEGIN
RETURN;
END
INSERT INTO UngDung(MaUD, TenUD, ChietKhau)
VALUES (@MaUD, @TenUD, @ChietKhau)
END

-- chay cau lenh tren--
exec dbo.ThemUngDungMoi @MaUD='UD05', @TenUD=N'Loship', @ChietKhau=25
GO

--Xoa ung dung--
CREATE PROCEDURE [dbo].[proc_XoaUngDung]
@MaUD nchar(11)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRANSACTION;
BEGIN TRY
DELETE FROM UngDung WHERE MaUD = @MaUD;
END TRY
BEGIN CATCH
DECLARE @err NVARCHAR(MAX)
SELECT @err = N'Lỗi ' + ERROR_MESSAGE()
RAISERROR(@err, 16, 1)
ROLLBACK TRANSACTION;
THROW;
END CATCH
COMMIT TRANSACTION;
END

--chay cau lenh xoa ung dung--
exec dbo.proc_XoaUngDung @MaUD='UD06'
GO

-- Sua thong tin ung dung
CREATE PROCEDURE [dbo].[proc_SuaUngDung]
	@MaUD nchar(10),
	@TenUD nvarchar(50),
	@ChietKhau int
AS
BEGIN
	BEGIN TRY
		-- Sửa thông tin hóa đơn bán
		UPDATE dbo.UngDung 
		SET MaUD = @MaUD, TenUD = @TenUD, ChietKhau = @ChietKhau
		WHERE MaUD = @MaUD
	END TRY
	BEGIN CATCH
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = N'Lỗi' + ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO
------------------------------------------------------------------------------------------
-- HÓA ĐƠN ỨNG DỤNG
-- Thêm hóa đơn ung dung
CREATE PROCEDURE [dbo].[proc_ThemHoaDonUngDung]
	@MaHD_UD nchar(10),
	@Ngay date,
	@SDT nchar(11),
	@MaUD nchar(10),
	@MaNV nchar(10),
	@GiaTriHD int
AS
BEGIN
	INSERT INTO HoaDonUngDung(MaHD_UD, Ngay, SDT, MaUD, MaNV, GiaTriHD)
	VALUES (@MaHD_UD, @Ngay, @SDT, @MaUD, @MaNV, @GiaTriHD)
END
GO

-- Cập nhật hóa đơn ung dung
CREATE PROCEDURE [dbo].[proc_SuaHoaDonUngDung]
	@MaHD_UD nchar(10),
	@Ngay date,
	@SDT nchar(11),
	@MaUD nchar(10),
	@MaNV nchar(10),
	@GiaTriHD int
AS
BEGIN
	BEGIN TRY
		-- Sửa thông tin hóa đơn Ung Dung
		UPDATE dbo.HoaDonUngDung 
		SET Ngay = @Ngay, SDT=@SDT, MaUD = @MaUD, MaNV = @MaNV, GiaTriHD = @GiaTriHD
		WHERE MaHD_UD = @MaHD_UD
	END TRY
	BEGIN CATCH
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = N'Lỗi' + ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

-- Xóa hóa đơn ung dung
CREATE PROCEDURE [dbo].[proc_XoaHoaDonUngDung]
@MaHD_UD nchar(10)
AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			-- Xoá các chi tiết hóa đơn bán theo @MaHD_UD trong bảng ChiTietHoaDonUngDung
			DELETE FROM dbo.ChiTietHoaDonUngDung WHERE ChiTietHoaDonUngDung.MaHD_UD = @MaHD_UD
			-- Xoá hóa đơn bán theo @MaHD_UD trong bảng HoaDonUngDung
			DELETE FROM dbo.HoaDonUngDung WHERE HoaDonUngDung.MaHD_UD = @MaHD_UD
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK
			DECLARE @err NVARCHAR(MAX)
			SELECT @err = N'Lỗi' + ERROR_MESSAGE()
			RAISERROR(@err, 16, 1)
		END CATCH
END
GO
------------------------------------------------------------------------------------------
-- CHI TIẾT ỨNG DỤNG
-- Thêm chi tiết đơn ung dung
CREATE PROCEDURE [dbo].[proc_ThemChiTietHoaDonUngDung]
	@MaHD_UD nchar(10),
	@MaSP nchar(10),
	@SoLuong int,
	@DonGia float,
	@TongTien float
AS
BEGIN
	INSERT INTO ChiTietHoaDonUngDung(MaHD_UD, MaSP, SoLuong, DonGia, TongTien)
	VALUES (@MaHD_UD, @MaSP, @SoLuong, @DonGia, @TongTien)
END
GO

-- Sửa chi tiết đơn ung dung
CREATE PROCEDURE [dbo].[proc_SuaChiTietHoaDonUngDung]
	@MaHD_UD nchar(10),
	@MaSP nchar(10),
	@SoLuong int,
	@DonGia float,
	@TongTien float
AS
BEGIN
	BEGIN TRY
		-- Sửa thông tin chi tiết đơn ung dung
		UPDATE dbo.ChiTietHoaDonUngDung 
		SET SoLuong = @SoLuong, DonGia = @DonGia, TongTien = @TongTien
		WHERE MaHD_UD = @MaHD_UD AND MaSP = @MaSP
	END TRY
	BEGIN CATCH
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = N'Lỗi' + ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

-- Xóa chi tiết đơn ung dung
CREATE PROCEDURE [dbo].[proc_XoaChiTietHoaDonUngDung]
	@MaHD_UD nchar(10),
	@MaSP nchar(10)
AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			-- Xoá chi tiết đơn ung dung theo @MaHD_UD và @MaSP trong bảng ChiTietHoaDonUngDung
			DELETE FROM dbo.ChiTietHoaDonUngDung WHERE ChiTietHoaDonUngDung.MaHD_UD = @MaHD_UD AND ChiTietHoaDonUngDung.MaSP = @MaSP
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK
			DECLARE @err NVARCHAR(MAX)
			SELECT @err = N'Lỗi' + ERROR_MESSAGE()
			RAISERROR(@err, 16, 1)
		END CATCH
END
GO

-- Tính tổng tiền bên chi tiết hóa đơn sau đó cập nhật qua hóa đơn ứng dụng
CREATE PROCEDURE [dbo].[proc_TinhTongTienHoaDonUngDung]
    @MaHD_UD nchar(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE HoaDonUngDung
    SET GiaTriHD = (SELECT SUM(TongTien)
                     FROM ChiTietHoaDonUngDung
                     WHERE ChiTietHoaDonUngDung.MaHD_UD = HoaDonUngDung.MaHD_UD
                     GROUP BY MaHD_UD)
    WHERE MaHD_UD = @MaHD_UD
      AND EXISTS (SELECT 1
                  FROM ChiTietHoaDonUngDung
                  WHERE ChiTietHoaDonUngDung.MaHD_UD = HoaDonUngDung.MaHD_UD
                  GROUP BY MaHD_UD);
END;
GO
------------------------------------------------------------------------------------------
-- LOẠI SẢN PHẨM
-- Thêm loại sản phẩm
CREATE PROCEDURE [dbo].[proc_ThemLoaiSanPham]
	@MaLoaiSP nchar(10),
	@TenLoaiSP nvarchar(50)
AS
BEGIN
	INSERT INTO LoaiSanPham(MaLoaiSP,TenLoaiSP )
	VALUES (@MaLoaiSP, @TenLoaiSP)
END
GO

-- Cập nhật loại sản phẩm
CREATE PROCEDURE [dbo].[proc_SuaLoaiSanPham]
	@MaLoaiSP nchar(10),
	@TenLoaiSP nvarchar(50)
AS
BEGIN
	BEGIN TRY
		-- Sửa thông tin loại sản phẩm
		UPDATE dbo.LoaiSanPham
		SET MaLoaiSP = @MaLoaiSP, TenLoaiSP = @TenLoaiSP
		WHERE MaLoaiSP = @MaLoaiSP
	END TRY
	BEGIN CATCH
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = N'Cập nhật loại sản phẩm không thành công' + ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

-- Xóa loại sản phẩm
CREATE PROCEDURE [dbo].[proc_XoaLoaiSanPham]
@MaLoaiSP nchar(10)
AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			-- Xoá các các sản phẩm thuộc loại sản phẩm bị xóa theo @MaLoaiSP trong bảng SanPham
			DELETE FROM dbo.SanPham WHERE SanPham.MaLoaiSP = @MaLoaiSP
			-- Xoá loại sản phẩm theo @MaLoaiSP trong bảng LoaiSanPham
			DELETE FROM dbo.LoaiSanPham WHERE LoaiSanPham.MaLoaiSP = @MaLoaiSP
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK
			DECLARE @err NVARCHAR(MAX)
			SELECT @err = N'Xóa loại sản phẩm không thành công' + ERROR_MESSAGE()
			RAISERROR(@err, 16, 1)
		END CATCH
END
GO

-- SẢN PHẨM
-- Thêm sản phẩm
CREATE PROCEDURE [dbo].[proc_ThemSanPham]
 @MaSP nchar(10),
 @TenSP nvarchar(50),
 @DonGia float,
 @TinhTrang nchar(10),
 @MaLoaiSP nchar(10),
 @TenLoaiSP nvarchar(50)
AS
BEGIN
 BEGIN TRANSACTION
BEGIN TRY
-- Kiểm tra xem loại sản phẩm đã tồn tại hay chưa
IF NOT EXISTS (SELECT * FROM LoaiSanPham WHERE MaLoaiSP =
@MaLoaiSP)
BEGIN
-- Nếu chưa tồn tại, thêm mới loại sản phẩm
INSERT INTO LoaiSanPham (MaLoaiSP, TenLoaiSP)
VALUES (@MaLoaiSP, @TenLoaiSP)
END
-- Thêm mới sản phẩm
INSERT INTO SanPham (MaSP, TenSP, DonGia, TinhTrang, MaLoaiSP)
VALUES (@MaSP, @TenSP, @DonGia, @TinhTrang, @MaLoaiSP)
COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK
DECLARE @err NVARCHAR(MAX)
SELECT @err = N'Thêm sản phẩm không thành công' + ERROR_MESSAGE()
RAISERROR(@err, 16, 1)
END CATCH
END
GO

-- Sửa sản phẩm
CREATE PROCEDURE [dbo].[proc_SuaSanPham]
 @MaSP nchar(10),
 @TenSP nvarchar(50),
 @DonGia float,
 @TinhTrang nchar(10)
AS
BEGIN
BEGIN TRY
-- Cập nhật thông tin sản phẩm
UPDATE dbo.SanPham SET MaSP = @MaSP, TenSP = @TenSP, DonGia =
@DonGia,
TinhTrang = @TinhTrang
WHERE MaSP = @MaSP
END TRY
BEGIN CATCH
DECLARE @err NVARCHAR(MAX)
SELECT @err = N'Cập nhật thông tin sản phẩm không thành công' + ERROR_MESSAGE()
RAISERROR(@err, 16, 1)
END CATCH
END
GO

-- Xóa sản phẩm
CREATE PROCEDURE [dbo].[proc_XoaSanPham]
@MaSP nchar(10)
AS
BEGIN
BEGIN TRANSACTION
BEGIN TRY
--Xoá nguyên liệu tiêu tốn theo @MaSP trong bảng CheBien
DELETE FROM dbo.CheBien WHERE CheBien.MaSP = @MaSP
--Xoá sản phẩm theo @MaSP trong bảng SanPham
DELETE FROM dbo.SanPham WHERE SanPham.MaSP = @MaSP
COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK
DECLARE @err NVARCHAR(MAX)
SELECT @err = N'Xóa sản phẩm không thành công' + ERROR_MESSAGE()
RAISERROR(@err, 16, 1)
END CATCH
END
GO
------------------------------------------------------------------------------------------
-- NGUYÊN LIỆU
-- Thêm nguyên liệu
CREATE PROCEDURE [dbo].[proc_ThemNguyenLieu]
@MaNL nchar(10),
@TenNL nvarchar(50),
@MaNCC nchar(10),
@TenNCC nvarchar(50),
@SDT nchar(10),
@SoLuong int,
@DonVi nchar(10)
AS
BEGIN
 BEGIN TRANSACTION
BEGIN TRY
-- Kiểm tra xem nhà cung cấp đã tồn tại hay chưa
IF NOT EXISTS (SELECT * FROM NhaCungCap WHERE MaNCC = @MaNCC)
BEGIN
-- Nếu chưa tồn tại, thêm mới nhà cung cấp
INSERT INTO NhaCungCap(MaNCC, TenNCC, SDT )
VALUES (@MaNCC, @TenNCC,@SDT)
END
-- Thêm mới nguyên liệu
INSERT INTO NguyenLieu(MaNL, TenNL, MaNCC, SoLuong, DonVi)
VALUES (@MaNL, @TenNL, @MaNCC, @SoLuong, @DonVi)
COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK
DECLARE @err NVARCHAR(MAX)
SELECT @err = N'Thêm nguyên liệu không thành công' + ERROR_MESSAGE()
RAISERROR(@err, 16, 1)
END CATCH
END
GO

-- Cập nhật nguyên liệu
CREATE PROCEDURE [dbo].[proc_SuaNguyenLieu]
@MaNL nchar(10),
@TenNL nvarchar(50),
@MaNCC nchar(10),
@TenNCC nvarchar(50),
@SDT nchar(10),
@SoLuong int,
@DonVi nchar(10)
AS
BEGIN
BEGIN TRANSACTION
BEGIN TRY
-- Kiểm tra xem nhà cung cấp đã tồn tại hay chưa
IF NOT EXISTS (SELECT * FROM NhaCungCap WHERE MaNCC = @MaNCC)
BEGIN
-- Nếu chưa tồn tại, thêm mới nhà cung cấp
INSERT INTO NhaCungCap(MaNCC, TenNCC, SDT )
VALUES (@MaNCC, @TenNCC,@SDT)
END
-- Cập nhật thông tin nguyên liệu
		UPDATE dbo.NguyenLieu 
		SET TenNL = @TenNL, MaNCC = @MaNCC, SoLuong = @SoLuong, DonVi = @DonVi
		WHERE MaNL = @MaNL
	END TRY
	BEGIN CATCH
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = N'Cập nhật thông tin nguyên liệu không thành công ' + ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

-- Xóa nguyên liệu
CREATE PROCEDURE [dbo].[proc_XoaNguyenLieu]
	@MaNL nchar(10)
AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			-- Xoá nguyên liệu theo @MaNL trong bảng NguyenLieu
			DELETE FROM dbo.NguyenLieu WHERE NguyenLieu.MaNL = @MaNL
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK
			DECLARE @err NVARCHAR(MAX)
			SELECT @err = N'Xóa nguyên liệu không thành công' + ERROR_MESSAGE()
			RAISERROR(@err, 16, 1)
		END CATCH
END
GO
------------------------------------------------------------------------------------------
-- CHẾ BIẾN
-- Thêm nguyên liệu chế biến
CREATE PROCEDURE [dbo].[proc_ThemCheBien]
	@MaSP nchar(10),
	@TenSP nvarchar(50),
	@MaNL nchar(10),
	@TenNL nvarchar(50),
	@LieuLuong int,
	@DonVi nchar(10)
AS
BEGIN
BEGIN TRANSACTION
BEGIN TRY
-- Kiểm tra xem sản phẩm đã tồn tại hay chưa
IF NOT EXISTS (SELECT * FROM SanPham WHERE MaSP = @MaSP)
BEGIN
-- Nếu chưa tồn tại, thêm mới sản phẩm
INSERT INTO SanPham(MaSP, TenSP )
VALUES (@MaSP, @TenSP)
END
-- Kiểm tra xem nguyên liệu đã tồn tại hay chưa
IF NOT EXISTS (SELECT * FROM NguyenLieu WHERE MaNL = @MaNL)
BEGIN
-- Nếu chưa tồn tại, thêm mới nguyên liệu
INSERT INTO NguyenLieu(MaNL, TenNL, DonVi )
VALUES (@MaNL, @TenNL, @DonVi)
END
-- Thêm mới nguyên liệu chế biến
INSERT INTO CheBien(MaSP, MaNL, LieuLuong, DonVi )
VALUES (@MaSP, @MaNL, @LieuLuong, @DonVi)
COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK
DECLARE @err NVARCHAR(MAX)
SELECT @err = N'Thêm nguyên liệu vào cách chế biến không thành công' + ERROR_MESSAGE()
RAISERROR(@err, 16, 1)
END CATCH
END
GO

-- Cập nhật cách chế biến
CREATE PROCEDURE [dbo].[proc_SuaCheBien]
	@MaSP nchar(10),
	@MaNL nchar(10),
	@TenNL nvarchar(50),
	@LieuLuong int,
	@DonVi nchar(10)
AS
BEGIN
BEGIN TRANSACTION
BEGIN TRY
-- Kiểm tra xem nguyên liệu đã tồn tại hay chưa
IF NOT EXISTS (SELECT * FROM NguyenLieu WHERE MaNL = @MaNL)
BEGIN
-- Nếu chưa tồn tại, thêm mới nguyên liệu
INSERT INTO NguyenLieu(MaNL, TenNL, DonVi )
VALUES (@MaNL, @TenNL, @DonVi)
END
-- Sửa thông tin chế biến
		UPDATE dbo.CheBien
		SET  LieuLuong = @LieuLuong, DonVi = @DonVi
		WHERE MaSP = @MaSP AND MaNL = @MaNL
	END TRY
	BEGIN CATCH
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = N'Cập nhật cách chế biến không thành công' + ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

-- Xóa chế biến
CREATE PROCEDURE [dbo].[proc_XoaCheBien]
@MaSP nchar(10),
@MaNL nchar(10)
AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			-- Xoá cách chế biến theo @MaSP, @MaNL trong bảng CheBien
			DELETE FROM dbo.CheBien WHERE MaSP = @MaSP AND MaNL = @MaNL
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK
			DECLARE @err NVARCHAR(MAX)
			SELECT @err = N'Xóa cách chế biến không thành công' + ERROR_MESSAGE()
			RAISERROR(@err, 16, 1)
		END CATCH
END
GO