# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_variants.rb


require 'helper'

class TestVariants < MiniTest::Test

  def variants( name )  SportDb::Import::Variant.find( name ); end


  def test_de
    assert_equal [],                             variants( 'Augsburg' )

    assert_equal ['Koln', 'Koeln'],              variants( 'Köln' )
    assert_equal ['1. FC Koln', '1. FC Koeln'],  variants( '1. FC Köln' )

    assert_equal ['Bayern Munchen', 'Bayern Muenchen'], variants( 'Bayern München' )
    assert_equal ['F. Dusseldorf', 'F. Duesseldorf'],   variants( 'F. Düsseldorf' )
    assert_equal ['Preussen'], variants( 'Preußen' )
    assert_equal ['Munster Preussen', 'Muenster Preussen'], variants( 'Münster Preußen' )
    assert_equal ['Rot-Weiss Oberhausen'], variants( 'Rot-Weiß Oberhausen' )

    assert_equal ['St. Polten', 'St. Poelten'], variants( 'St. Pölten' )
  end


end # class TestVariants