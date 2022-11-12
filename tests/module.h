#ifndef __MODULE_H__
#define __MODULE_H__

#if defined(__cplusplus)
#define INTERNAL CXXSYM
#elif !defined(__cplusplus) && defined(__IAR_SYSTEMS_ICC__)
#define INTERNAL CSYMBOL
#elif defined(__IAR_SYSTEMS_ASM__)
#define INTERNAL ASMSYM
#else
#error "Unable to determine INTERNAL symbol."
#endif /* __IAR_SYSTEMS_ICC */

#endif /* __MODULE_H__ */
