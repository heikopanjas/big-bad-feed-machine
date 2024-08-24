////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) ultralove contributors (https://github.com/ultralove)
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////

#ifndef __NMCS_PLATFORM_H_INCL__
#define __NMCS_PLATFORM_H_INCL__

#include <nmcs/common.h>
#include <nmcs/globals.h>

#include <nmcs/platformalloc.h>
#include <nmcs/platformguid.h>
#include <nmcs/platformvault.h>

#pragma pack(push)
#pragma pack(8)

namespace ultralove { namespace nmcs { namespace platform {
namespace nmcs = ultralove::nmcs;
}}} // namespace ultralove::nmcs::platform

#ifdef _MSC_VER
   #define NmcsByteSwap16(x) _byteswap_ushort(x)
   #define NmcsByteSwap32(x) _byteswap_ulong(x)
   #define NmcsByteSwap64(x) _byteswap_uint64(x)
#else
   #define NmcsByteSwap16(x) __builtin_bswap16(x)
   #define NmcsByteSwap32(x) __builtin_bswap32(x)
   #define NmcsByteSwap64(x) __builtin_bswap64(x)
#endif

#pragma pack(pop)

#endif // #ifndef __NMCS_PLATFORM_H_INCL__
