import unittest

from primes import primes

class TestPrimes(unittest.TestCase):
    def test_primes(self):
        self.assertEqual(primes(10), [2, 3, 5, 7])
        self.assertEqual(primes(1), [])
        self.assertEqual(primes(2), [2])

if __name__ == '__main__':
    unittest.main()