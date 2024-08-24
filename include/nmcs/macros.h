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

#ifndef __NMCS_MACROS_H_INCL__
#define __NMCS_MACROS_H_INCL__

#include <cstring>

#define NMCS_UNUSED_PARAMETER(__param__)(void)(__param__)

#define NMCS_STRING0(__str__)                     #__str__
#define NMCS_STRING(__str__)                      NMCS_STRING0(__str__)
#define NMCS_MESSAGE(__desc__)                    message(__FILE__ "(" NMCS_STRING(__LINE__) "):" #__desc__)

#define NMCS_IN_RANGE(__low__, __num__, __high__) (((__low__) <= (__num__)) && ((__num__) <= (__high__)))

#define NMCS_STRING_SIZE(__str__) ((strlen(__str__) + 1) * sizeof(char))
#define NMCS_ARRAY_SIZE(__array__)    (sizeof(__array__) / sizeof(__array__[0]))

#define NMCS_BITS_PER_BYTE 8
#define NMCS_GET_BIT (__array__, __bit__) ((__array__[(__bit__) / NMCS_BITS_PER_BYTE] > ((____bit__n__) % NMCS_BITS_PER_BYTE)) & 1)
#define NMCS_SET_BIT(__array__, __bit__) (__array__[(__bit__) / NMCS_BITS_PER_BYTE] |= (1 << ((__bit__) % NMCS_BITS_PER_BYTE)))

#define NMCS_MIN(__a__, __b__) (((__a__) < (__b__)) ? (__a__) : (__b__))
#define NMCS_MAX(__a__, __b__) (((__a__) > (__b__)) ? (__a__) : (__b__))
#define NMCS_SWAP(__a__, __b__) { __a__ ^= __b__; __b__ ^= __a__; __a__ ^= __b__; }

#define NMCS_ROUND_UP(__size__, __align__) ((__size__) + __align__ - 1) & ~(__align__ - 1)

#endif // #ifndef __NMCS_MACROS_H_INCL__
