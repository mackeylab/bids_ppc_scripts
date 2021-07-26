#!/usr/bin/env python
import sys
import numpy as np
import nibabel as nb


def test(img):
    zooms = np.array([img.header.get_zooms()[:3]])
    A = img.affine[:3, :3]

    cosines = A / zooms
    diff = A - cosines * zooms.T

    return not np.allclose(diff, 0), np.max(np.abs(diff))


if __name__ == "__main__":
    for fname in sys.argv[1:]:
        affected, severity = test(nb.load(fname))
        print(f"{fname} has severity ({severity})")
        if affected:
            print(f"{fname} is affected ({severity})")
