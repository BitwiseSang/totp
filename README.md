# Time-based one-time password (TOTP)

An implementation of Time-based one-time password(TOTP) to understand how it
works. This implementation is for educational purposes only and should not be
used any security-critical applications.
The language used is Ruby version 4.0.0.

## What is TOTP?

TOTP is a computer algorithm that generates a one-time password(OTP) using
the current time as a source of uniqueness. It is an extension of the HMAC-based
one-time password (HOTP) algorithm and is specified in RFC 6238.

## Algorithm

Since TOTP is an extension of HOTP, it uses the same basic algorithm as HOTP,
but extends it using two additional parameters: a time step and an epoch.

This algorithm involves **symetric** generation of one-time passwords based on a
shared parameter set between the client and server. Symetric generation means
that the generation of the OTP is done by both the authenticator (server) and
the client (user) using the same parameters and secret key.

### Parameters

Let's look at the parameters involved in both HOTP and TOTP.

#### HOTP Parameters

Parties intending to use HOTP must establish some parameters; these are
typically specified by the authenticator, and either accepted or not by the
authenticated entity. The parameters are:

- **A cryptographic hash `H`** (defaulting to SHA-1)
- **A secret key `K`**, which is a random byte-string that must remain private.
- **A counter `C`** which counts the number of iterations (or time steps in
TOTP).
- **A HOTP-value length `d`**(6-10, default is 6, and 6-8 is recommended). This
is the *length of the one-time password to generate*.

Both the client and server increment the counter `C` independently.

#### TOTP Parameters

In addition to the HOTP parameters, TOTP requires two additional parameters:

- **T<sub>0</sub>**: The Unix time to start counting time steps (default is 0).
- **T<sub>x</sub>**: An interval which will be used to calculate the value of
the Counter **C<sub>T</sub>** (default is 30 seconds).

---

### Steps to generate TOTP

TOTP uses the HOTP but substitutes the counter `C` with a non-decreasing value
based on the current unix time (**C<sub>T</sub>**):

> TOTP Value = HOTP value(K, C<sub>T</sub>),

Calculated as:

![Counter calculation](https://wikimedia.org/api/rest_v1/media/math/render/svg/48bf4f594b18b954caab5457f2efed6aa6082432)

where

- **C<sub>T</sub>** is the count of the number of durations TX between T0 and T,
- **T** is the current time in seconds since a particular epoch,
- **T<sub>0</sub>** is the epoch as specified in seconds since the Unix epoch
(e.g. if using Unix time, then T0 is 0),
- **T<sub>X</sub>** is the length of one-time duration (e.g. 30 seconds).
