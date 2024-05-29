CREATE DATABASE QLQuanTraSua
GO

-- Tạo CSDL QLTS
USE QLQuanTraSua
GO

-- Bảng vị trí công việc
CREATE TABLE ViTriCongViec(
	MaViTri nchar(10) CONSTRAINT PK_ViTri PRIMARY KEY,
	TenViTri nvarchar(50) NOT NULL,
	PhuCapLuong float check (PhuCapLuong > 0)
)

-- Bảng loại nhân viên
CREATE TABLE LoaiNhanVien(
	MaLoaiNV nchar(10) CONSTRAINT PK_LoaiNV PRIMARY KEY,
	TenLoaiNV nvarchar(50) NOT NULL,
	LuongCB float check (LuongCB > 0),
)
-- Bảng nhân viên
CREATE TABLE NhanVien(
	MaNV nchar(10) CONSTRAINT PK_NhanVien PRIMARY KEY,
	TenNV nvarchar(10) NOT NULL,
	NgaySinh date check (DATEDIFF(year, NgaySinh, GETDATE())>=18),
	GioiTinh nvarchar(3) NOT NULL,
	DiaChi nvarchar(100),
	SDT nchar(11) NOT NULL check (len(SDT)=10),
	MaLoaiNV nchar(10) CONSTRAINT FK_NhanVien_Loai FOREIGN KEY REFERENCES LoaiNhanVien(MaLoaiNV),
	MaViTri nchar(10) CONSTRAINT FK_NhanVien_ViTri FOREIGN KEY REFERENCES ViTriCongViec(MaViTri),
	NgayTuyenDung date check (DATEDIFF(day, NgayTuyenDung, GETDATE())>=0)
)

-- Bảng khách hàng
CREATE TABLE KhachHang(
	SDT nchar(11) CONSTRAINT PK_KhachHang PRIMARY KEY check (len(SDT)=10),
	TenKH nvarchar(50) NOT NULL,
	DiaChi nchar(100)
)

-- Bảng nhà cung cấp
CREATE TABLE NhaCungCap(
	MaNCC nchar(10) CONSTRAINT PK_NhaCungCap PRIMARY KEY,
	TenNCC nvarchar(50) NOT NULL,
	DiaChi nchar(100),
	SDT nchar(10) NOT NULL check (len(SDT)=10)
)

-- Bảng hóa đơn nhập
CREATE TABLE HoaDonNhap(
	MaHDN nchar(10) CONSTRAINT PK_HoaDonNhap PRIMARY KEY,
	NgayNhap date check (DATEDIFF(day, NgayNhap, GETDATE())>=0),
	TriGiaDonNhap float NOT NULL,
	MaNCC nchar(10) CONSTRAINT FK_HoaDonNhap_NCC FOREIGN KEY REFERENCES NhaCungCap(MaNCC),
)

-- Bảng nguyên liệu
CREATE TABLE NguyenLieu(
	MaNL nchar(10) CONSTRAINT PK_NguyenLieu PRIMARY KEY,
	TenNL nvarchar(50) NOT NULL,
	MaNCC nchar(10) CONSTRAINT FK_NguyenLieu_NCC FOREIGN KEY REFERENCES NhaCungCap(MaNCC),
	SoLuong int check (SoLuong>0),
	DonVi nchar(10) NOT NULL,
)

-- Bảng chi tiết đơn nhập
CREATE TABLE ChiTietDonNhap(
	MaHDN nchar(10) CONSTRAINT FK_ChiTietNH_DonNH FOREIGN KEY REFERENCES HoaDonNhap(MaHDN),
	MaNL nchar(10) CONSTRAINT FK_ChiTietDN_NL FOREIGN KEY REFERENCES NguyenLieu(MaNL),
	DonGia float check (DonGia>=0),
	SoLuong int check (SoLuong>0),
	DonVi nchar(10) NOT NULL,
	TongTien float check (TongTien>=0),
	CONSTRAINT PK_ChiTietNhapHang PRIMARY KEY (MaHDN, MaNL)
)

-- Bảng loại sản phẩm
CREATE TABLE LoaiSanPham(
	MaLoaiSP nchar(10) CONSTRAINT PK_LoaiSanPham PRIMARY KEY,
	TenLoaiSP nvarchar(50) NOT NULL
)

-- Bảng sản phẩm
CREATE TABLE SanPham(
	MaSP nchar(10) CONSTRAINT PK_MaSP PRIMARY KEY,
	TenSP nvarchar(50) NOT NULL,
	DonGia float check (DonGia>0),
	TinhTrang nchar(10) DEFAULT N'Hết hàng',
	MaLoaiSP nchar(10) CONSTRAINT FK_SanPham_LoaiSP FOREIGN KEY REFERENCES LoaiSanPham(MaLoaiSP)
)

-- Bảng ứng dụng
CREATE TABLE UngDung(
	MaUD nchar(10) CONSTRAINT PK_UngDung PRIMARY KEY,
	TenUD nvarchar(50) NOT NULL,
	ChietKhau int NOT NULL
)

-- Bảng hóa đơn
CREATE TABLE HoaDonBan(
	MaHDB nchar(10) CONSTRAINT PK_HoaDonBan PRIMARY KEY,
	Ngay date check (DATEDIFF(year, Ngay, GETDATE())>=0),
	SDT nchar(11) CONSTRAINT FK_HoaDon_KH FOREIGN KEY REFERENCES KhachHang(SDT),
	MaNV nchar(10) CONSTRAINT FK_HoaDon_NV FOREIGN KEY REFERENCES NhanVien(MaNV),
	ThanhTien int check (ThanhTien>=0),
)

-- Bảng chi tiết đơn bán
CREATE TABLE ChiTietDonBan(
	MaHDB nchar(10) CONSTRAINT FK_ChiTietDB_DB FOREIGN KEY REFERENCES HoaDonBan(MaHDB),
	MaSP nchar(10) CONSTRAINT FK_ChiTietDB_SP FOREIGN KEY REFERENCES SanPham(MaSP),
	SoLuong int check (SoLuong>0),
	DonGia float check (DonGia>=0),
	TongTien float check (TongTien>=0),
	CONSTRAINT PK_ChiTietHD PRIMARY KEY (MaHDB, MaSP)
)

-- Bảng hóa đơn ứng dụng
CREATE TABLE HoaDonUngDung(
	MaHD_UD nchar(10) CONSTRAINT PK_HoaDonUngDung PRIMARY KEY,
	Ngay date check (DATEDIFF(day, Ngay, GETDATE())>=0),
	SDT nchar(11) CONSTRAINT FK_HoaDonUD_KH FOREIGN KEY REFERENCES KhachHang(SDT),
	MaUD nchar(10) CONSTRAINT FK_HoaDonUngDung_UD FOREIGN KEY REFERENCES UngDung(MaUD),
	MaNV nchar(10) CONSTRAINT FK_HoaDonUngDung_NV FOREIGN KEY REFERENCES NhanVien(MaNV),
	GiaTriHD int NOT NULL
)

-- Bảng chi tiết hóa đơn ứng dụng
CREATE TABLE ChiTietHoaDonUngDung(
	MaHD_UD nchar(10) CONSTRAINT FK_ChiTietHDUD_HDUD FOREIGN KEY REFERENCES HoaDonUngDung(MaHD_UD),
	MaSP nchar(10) CONSTRAINT FK_ChiTietHDUD_SP FOREIGN KEY REFERENCES SanPham(MaSP),
	SoLuong int check (SoLuong>0),
	DonGia float check (DonGia>=0),
	TongTien float check (TongTien>=0),
	CONSTRAINT PK_ChiTietHDUD PRIMARY KEY (MaHD_UD, MaSP)
)

-- Bảng ca làm việc
CREATE TABLE CaLamViec(
	MaCa nchar(10),
	Ngay date check (DATEDIFF(day, Ngay, GETDATE())>=0),
	GioBatDau nchar(10) NOT NULL,
	GioKetThuc nchar(10) NOT NULL,
	CONSTRAINT PK_CaLamViec PRIMARY KEY (MaCa, Ngay)
)

-- Bảng phân ca làm cho nhân viên
CREATE TABLE BangPhanCa(
	MaCa nchar(10),
	MaNV nchar(10) CONSTRAINT FK_PhanCa_NV FOREIGN KEY REFERENCES NhanVien(MaNV),
	Ngay date check (DATEDIFF(day, Ngay, GETDATE())>=0),
	CONSTRAINT PK_BangPhanCa PRIMARY KEY (MaCa, MaNV, Ngay),
	CONSTRAINT FK_PhanCa_Ca FOREIGN KEY (MaCa, Ngay) REFERENCES CaLamViec(MaCa, Ngay)
)

-- Bảng chế biến
CREATE TABLE CheBien(
	MaSP nchar(10) CONSTRAINT FK_CheBien_SP FOREIGN KEY REFERENCES SanPham(MaSP),
	MaNL nchar(10) CONSTRAINT FK_CheBien_NL FOREIGN KEY REFERENCES NguyenLieu(MaNL),
	LieuLuong int check (LieuLuong>0),
	DonVi nchar(10) NOT NULL
	CONSTRAINT PK_CheBien PRIMARY KEY (MaSP, MaNL)
)