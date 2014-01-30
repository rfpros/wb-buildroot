static const uint8_t e_0[3] = {
	0x01, 0x00, 0x01, 
};

static const uint8_t n_0[256] = {
	0xd6, 0x57, 0x99, 0x71, 0x88, 0xd3, 0x5d, 0xce, 
	0x2a, 0x2e, 0xad, 0x68, 0x37, 0x60, 0x24, 0xf2, 
	0xf2, 0xcf, 0xf3, 0x93, 0xf9, 0x70, 0x54, 0xeb, 
	0x0a, 0x9a, 0x9d, 0x48, 0x8e, 0x56, 0xe1, 0x53, 
	0xb0, 0x75, 0xa2, 0x41, 0xe1, 0x3b, 0x5a, 0xc5, 
	0x4d, 0x9f, 0x01, 0x37, 0x07, 0xfc, 0x0d, 0x84, 
	0xb0, 0x4d, 0xe1, 0xd6, 0xb3, 0x9f, 0xcc, 0x8d, 
	0x3e, 0x7c, 0x15, 0x7d, 0x0d, 0xc3, 0x8e, 0xab, 
	0x22, 0x03, 0xfb, 0x37, 0x48, 0x2c, 0x13, 0x1b, 
	0xf3, 0x12, 0xb9, 0x66, 0xff, 0xbb, 0xf0, 0xe9, 
	0x01, 0x1a, 0x5b, 0x3f, 0x5b, 0x3b, 0xc3, 0x0d, 
	0x58, 0x5d, 0x9a, 0x7d, 0x53, 0x44, 0x7b, 0xd1, 
	0xbe, 0x62, 0x72, 0xed, 0xc5, 0xf5, 0x98, 0x24, 
	0xf9, 0xe9, 0xc9, 0xc7, 0xad, 0x93, 0x3f, 0x64, 
	0x16, 0x85, 0xc1, 0x57, 0xe2, 0x0f, 0xd4, 0xdc, 
	0xaa, 0xa8, 0xac, 0xc8, 0x5d, 0x6c, 0xa8, 0x4e, 
	0x7e, 0x70, 0xc1, 0xd3, 0x59, 0x16, 0xf1, 0x73, 
	0x5f, 0xab, 0xb6, 0x88, 0xeb, 0xd1, 0xe1, 0x98, 
	0xac, 0xd7, 0xca, 0xdb, 0x46, 0xb0, 0x94, 0x3e, 
	0x4a, 0x56, 0x3e, 0x84, 0x8f, 0x3a, 0x2d, 0xaf, 
	0xd1, 0x03, 0x58, 0x0b, 0x0b, 0xd5, 0xb1, 0xff, 
	0x90, 0x67, 0xcc, 0x76, 0x7a, 0x6e, 0xb5, 0xcc, 
	0x8c, 0x6a, 0x92, 0xd0, 0xa5, 0x15, 0x6b, 0xb8, 
	0xef, 0xe3, 0x11, 0xd8, 0xd2, 0x9a, 0x10, 0x04, 
	0xfe, 0xc8, 0xf5, 0xb6, 0x61, 0xdc, 0x01, 0x70, 
	0x53, 0xea, 0x3e, 0x5a, 0x97, 0x83, 0x9a, 0x2e, 
	0x20, 0x5a, 0x5a, 0x73, 0xfe, 0xfa, 0xbb, 0xa7, 
	0x7b, 0xba, 0xe3, 0x8a, 0x6c, 0x1f, 0xce, 0x9d, 
	0x39, 0xe3, 0xdf, 0xeb, 0xba, 0x94, 0x14, 0x33, 
	0xb9, 0xc0, 0x65, 0x10, 0xcb, 0xcb, 0x35, 0xe3, 
	0xdc, 0x9f, 0xca, 0x11, 0xc8, 0xba, 0x75, 0x7b, 
	0x63, 0xa2, 0x70, 0x54, 0x16, 0xa0, 0xd8, 0xe1, 
};


struct key_params {
	const uint8_t *e, *n;
	uint32_t len_e, len_n;
};

#define KEYS(_e, _n) {			\
	.e = _e, .len_e = sizeof(_e),	\
	.n = _n, .len_n = sizeof(_n),	\
}

static const struct key_params keys[] = {
	KEYS(e_0, n_0),
};
