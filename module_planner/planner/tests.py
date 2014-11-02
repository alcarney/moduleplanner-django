from django.test import SimpleTestCase

# Thanks to @JasYoung314 for firguring this out
class simple_tests(SimpleTestCase):

    def test_math(self):
        self.assertEqual(1 + 1, 3)
