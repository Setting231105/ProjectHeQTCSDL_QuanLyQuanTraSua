USE QLQuanTraSua
GO

-- View Hóa đơn bán
CREATE VIEW [dbo].[v_HoaDonBan] AS
SELECT *
FROM dbo.HoaDonBan
GO
------------------------------------------------------------------------------------------
-- View Chi tiết đơn bán
CREATE VIEW [dbo].[v_ChiTietDonBan] AS
SELECT *
FROM dbo.ChiTietDonBan
GO
------------------------------------------------------------------------------------------
-- View Nhà Cung Cấp
CREATE VIEW [dbo].[v_NhaCungCap] AS
SELECT *
FROM dbo.NhaCungCap
GO
------------------------------------------------------------------------------------------
-- View Hóa đơn nhập
CREATE VIEW [dbo].[v_HoaDonNhap] AS
SELECT *
FROM dbo.HoaDonNhap
GO
------------------------------------------------------------------------------------------
-- View chi tiết đơn nhập
CREATE VIEW [dbo].[v_ChiTietDonNhap] AS
SELECT *
FROM dbo.ChiTietDonNhap
GO
------------------------------------------------------------------------------------------
-- View nhân viên
CREATE VIEW [dbo].[v_NhanVien] AS
SELECT *
FROM dbo.NhanVien
GO
------------------------------------------------------------------------------------------
-- View khách hàng
CREATE VIEW [dbo].[v_KhachHang] AS
SELECT *
FROM dbo.KhachHang
GO
------------------------------------------------------------------------------------------
-- View sản phẩm
CREATE VIEW [dbo].[v_SanPham] AS
SELECT *
FROM dbo.SanPham
GO
------------------------------------------------------------------------------------------
-- View nguyên liệu
CREATE VIEW [dbo].[v_LoadNguyenLieu] AS
SELECT *
FROM NguyenLieu
GO
------------------------------------------------------------------------------------------
-- Danh mục bảng phân ca
CREATE VIEW [dbo].[v_LoadBangPhanCa] AS
SELECT CaLamViec.MaCa, NhanVien.MaNV, CaLamViec.Ngay
FROM BangPhanCa, CaLamViec, NhanVien
WHERE BangPhanCa.MaCa = CaLamViec.MaCa AND BangPhanCa.MaNV = NhanVien.MaNV AND BangPhanCa.Ngay = CaLamViec.Ngay
GO
------------------------------------------------------------------------------------------
-- Danh mục vị trí công việc
CREATE VIEW [dbo].[v_LoadViTriCongViec] AS
SELECT *
FROM ViTriCongViec
GO
------------------------------------------------------------------------------------------
-- Danh mục ca làm việc
CREATE VIEW [dbo].[v_LoadCaLamViec] AS
SELECT *
FROM CaLamViec
GO
------------------------------------------------------------------------------------------
-- Danh mục loại nhân viên
CREATE VIEW [dbo].[v_LoadLoaiNhanVien] AS
SELECT *
FROM LoaiNhanVien
GO
------------------------------------------------------------------------------------------
-- Danh mục nhân viên
CREATE VIEW [dbo].[v_LoadNhanVien] AS
SELECT MaNV, TenNV, NgaySinh, GioiTinh, DiaChi, SDT, LoaiNhanVien.MaLoaiNV, ViTriCongViec.MaViTri, NgayTuyenDung
FROM NhanVien, LoaiNhanVien, ViTriCongViec
WHERE NhanVien.MaLoaiNV = LoaiNhanVien.MaLoaiNV AND NhanVien.MaViTri = ViTriCongViec.MaViTri
GO
------------------------------------------------------------------------------------------
--Khach Hang--
--view xem thong tin khach hang
CREATE VIEW [dbo].[view_KhachHang] AS
SELECT *
FROM KhachHang
GO
------------------------------------------------------------------------------------------
--UNG DUNG--
CREATE VIEW [dbo].[view_UngDung] AS
SELECT *
FROM UngDung
GO
-----------------------------------------------------------------------------
--Hoa don ung dung
CREATE VIEW [dbo].[view_HoaDonUngDung] AS
SELECT *
FROM HoaDonUngDung
GO
---------------------------------------------------------------------------------------
-- BẢNG CHI TIẾT ĐƠN UNG DUNG
CREATE VIEW [dbo].[view_ChiTietHoadonUngDung] AS
SELECT *
FROM ChiTietHoaDonUngDung
GO

-- BẢNG LOẠI SẢN PHẨM
-- Danh mục loại sản phẩm
CREATE VIEW [dbo].[v_LoadLoaiSanPham] AS
SELECT *
FROM LoaiSanPham
GO
------------------------------------------------------------------
-- BẢNG SẢN PHẨM
-- Danh mục sản phẩm
CREATE VIEW [dbo].[v_LoadSanPham] AS
SELECT *
FROM SanPham
GO

-- Danh mục sản phẩm hiện tên loại
CREATE VIEW [dbo].[v_LoadXemSanPham] AS
SELECT SanPham.TenSP, SanPham.DonGia, SanPham.TinhTrang, LoaiSanPham.TenLoaiSP
FROM dbo.SanPham
INNER JOIN dbo.LoaiSanPham ON SanPham.MaLoaiSP = LoaiSanPham.MaLoaiSP
GO

-- Xem số lượng sản phẩm đã bán trong ngày
CREATE VIEW [dbo].[V_SoLuongSanPhamDaBanTrongNgay] AS
SELECT sp.MaSP, SUM(cthd.SoLuong) AS SoLuongDaBanTaiQuay, SUM(cthdUD.SoLuong) AS SoLuongDaBanQuaUD
FROM dbo.SanPham sp
	JOIN dbo.ChiTietDonBan cthd ON sp.MaSP = cthd.MaSP
	JOIN dbo.HoaDonBan hd ON cthd.MaHDB = hd.MaHDB
	JOIN dbo.ChiTietHoaDonUngDung cthdUD ON sp.MaSP = cthdUD.MaSP
	JOIN dbo.HoaDonUngDung hdUD ON cthdUD.MaHD_UD = hdud.MaHD_UD
	WHERE hd.Ngay = CONVERT(DATE, GETDATE()) AND hdud.Ngay = CONVERT(DATE,GETDATE())
GROUP BY sp.MaSP
GO

------------------------------------------------------------------
-- BẢNG CHẾ BIẾN
-- Danh mục chế biến
CREATE VIEW [dbo].[v_LoadCheBien] AS
SELECT *
FROM CheBien
GO

-- Danh mục cách chế biến
CREATE VIEW [dbo].[v_LoadCachCheBien] AS
SELECT SanPham.TenSP, NguyenLieu.TenNL, CheBien.LieuLuong, CheBien.DonVi
FROM dbo.CheBien
INNER JOIN dbo.SanPham ON SanPham.MaSP = CheBien.MaSP
INNER JOIN dbo.NguyenLieu ON CheBien.MaNL = NGUYENLIEU.MaNL
GO