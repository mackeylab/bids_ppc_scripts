**Why do we need this?**

The DTI TOPUP scan is giving the BIDS validator problems.

The fmap we get from the scanner has associated .bval and .bvec files which are not in the BIDS specification, because the TOPUP scan collects one b=0 and several b=1000. This is a bug, as it should only be some b0's in each direction, this is a glitch in the Siemens sequence.
Therefore, in order to make them BIDS-valid, we remove the b=1000 volumes, and remove the bval and bvec files.
Also, as a note, Siemens records some of our b=0's as b=5, and some of our b=1000's as b=1005's. The specified b-value is not always exactly what is collected, but we can treat them as such.

Often see people collect a few b=0 images, but strictly speaking you only need one b=0 in each encoding direction.
We have a b=0 in one direction at the end of our main DTI scan, and a b=0 in our TOPUP scan in the other direction, then we can use those two B0's to feed into TOPUP.

Basically, we copy out the last B0 volume from the diffusion scan (which is acquired in the -j direction) and the first volume from the TOPUP scan (which is acquired in the j direction), and rename them BIDS-valid names and put them in the fieldmap folder. Then, we copy the `.json` file for the diffusion scan over to  `subject/fmap` and rename it appropriately, as well as renaming the `.json` file for the TOPUP scan to the right name.  This is in order to preserve the needed information about `TotalReadoutTime` and `PhaseEncodingDirection`.

See also some posts on Neurostars here: https://neurostars.org/t/not-included-error-bval-and-bvec-fmap-files/4678/9

**NOTE**

I would check TOPUP/diffusion pipeline outputs, because I am uncertain whether the remaining information in the .json file about the other b=1000 volumes acquired will mess it up. Also may need to rewrite *scans.tsv* for each subject.

*Ursula 08/19* TOPUP scan qform_yorient and sform_yorient is Posterior-to-Anterior, so we think j direction is PA, and -j direction is AP. I have named the files accordingly.

**Way too much additional info**

Ari says:
"I'm not sure if there's a use for the b=1000, but the b=0 alone is definitely enough to run TOPUP   
Often see people collect a few b=0 images, but strictly speaking you only need one b=0 in each encoding direction. So if we have a b=0 in one direction in our main DTI scan, and a b=0 in our TOPUP scan in the other direction, then you pull out both of those volumes and feed them into TOPUP. It really doesn't matter a huge amount as long as people haven't moved around much between the two. I sorta remember from talking to Mark that there isn't any easy way with the siemens scanner to get both directions in the same sequence, but could be wrong on that"   
Anyways, if you want to play around with this, TOPUP should generate an 'unwarped' image, and if it's not messing anything up, that unwarped image should look way more like the T1/T2 structurals than either of the b=5s. Which is really where this comes into play anyways: running TOPUP to fix this distortion should mean you get better within-subject alignment between diffusion and other modalities. Those distortions are going to be fairly specific to the diffusion scan, so if you're trying to generate an atlas based on the subject's structural scan it's going to be a cleaner fit after running topup/eddy"

Matt Cieslak says:
The topup refs here have bvals and bvecs because of a glitch in the siemens diffusion sequence".   
Specifically, "It’s because the siemens diffusion sequence requires at least one non-b0 image to run. There is no option for acquiring just a single b=0 volume at the moment. If you write your own sampling schemes, which is how we’ve been doing it, the scanner automatically adds a b=0 to the beginning of the sequence. So if you request a b=0 and one b>0 (required) you end up with 2 b=0 scans and a b>0 scan."   
How to deal with it?   
I usually do `3dcalc -a 'fmap.nii.gz[0]' -expr '1*a' -prefix singlevolfmap.nii.gz` and delete the bvals and bvecs
or you can do `3dcalc -a 'fmap.nii.gz[0..N]' -expr '1*a' -prefix singlevolfmap.nii.gz` where N is the number of b=0 scans   
Are the b=1000’s useful at all?   
Topup can use them for “extra good” fieldmap estimation, it motion corrects all the scans with the same PE direction, then estimates warps between those means, if your scan has lots of slice dropout then this can be useful
