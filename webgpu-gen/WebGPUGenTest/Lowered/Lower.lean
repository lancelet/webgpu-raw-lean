import WebGPUGen.Lowered.Lower
import WebGPUGenTest.Resolved.Resolve

/-!
# Tests for lowering

Each test resolves a small spec, lowers it, and compares a part of the result
with the lowered model written out in full. The test driver also checks the
lowered real spec against `webgpu.h`.
-/

namespace WebGPUGenTest.Lowered.Lower
open WebGPUGen.Lowered WebGPUGen
open WebGPUGenTest.Resolved.Resolve (spec resolveText)

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- Resolve and lower a spec file, with the documentation sections given. -/
def lowerText (input : String) (sections : List (String × String) := []) :
    Option Lowered.Spec :=
  match resolveText input with
  | .ok r    => some (lower r sections)
  | .error _ => none

/-! ## Enums -/

-- Names on both sides; a reserved slot is left out but still shifts the
-- values after it; a keyword is quoted on the Lean side.
#guard
  let input := spec (enums := dedent "
    - name: address_mode
      doc: How to address.
      entries:
        - null
        - name: clamp_to_edge
          doc: Clamp.
        - name: repeat
          doc: Repeat.
    ")
  let expected : Lowered.Enum := {
    names    := {
      c    := "WGPUAddressMode"
      lean := "AddressMode"
    }
    doc      := "How to address."
    extended := false
    entries  := #[
      {
        names := {
          c    := "WGPUAddressMode_ClampToEdge"
          lean := "clampToEdge"
        }
        doc   := "Clamp."
        value := 0x00000001
      },
      {
        names := {
          c    := "WGPUAddressMode_Repeat"
          lean := "«repeat»"
        }
        doc   := "Repeat."
        value := 0x00000002
      }
    ]
  }
  (lowerText input).map (·.enums) == some #[expected]

/-! ## Bitflags -/

-- Each flag with its value; a combination's value is the OR of its flags.
#guard
  let input := spec (bitflags := dedent "
    - name: color_write_mask
      doc: Which channels.
      entries:
        - name: none
          doc: None.
        - name: red
          doc: Red.
        - name: green
          doc: Green.
        - name: RG_all
          doc: All.
          value_combination:
            - red
            - green
    ")
  let expected : Lowered.Bitflag := {
    names    := {
      c    := "WGPUColorWriteMask"
      lean := "ColorWriteMask"
    }
    doc      := "Which channels."
    extended := false
    flags    := #[
      {
        names := {
          c    := "WGPUColorWriteMask_None"
          lean := "none"
        }
        doc   := "None."
        value := 0x0000
      },
      {
        names := {
          c    := "WGPUColorWriteMask_Red"
          lean := "red"
        }
        doc   := "Red."
        value := 0x0001
      },
      {
        names := {
          c    := "WGPUColorWriteMask_Green"
          lean := "green"
        }
        doc   := "Green."
        value := 0x0002
      },
      {
        names := {
          c    := "WGPUColorWriteMask_RGAll"
          lean := "rgAll"
        }
        doc   := "All."
        value := 0x0003
      }
    ]
  }
  (lowerText input).map (·.bitflags) == some #[expected]

end WebGPUGenTest.Lowered.Lower
