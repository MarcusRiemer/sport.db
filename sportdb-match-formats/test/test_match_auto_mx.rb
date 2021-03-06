# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_match_auto_mx.rb


require 'helper'


class TestMatchAutoMx < MiniTest::Test

  def test_mx
    txt= <<TXT
Jornada 1  //  3, 4 y 5 de enero

Vie 3 Ene  Monarcas Morelia      vs. Querétaro      @ Estadio Morelos
Vie 3 Ene  Santos Laguna         vs. Guadalajara    @ Estadio Corona TSM
Sáb 4 Ene  América               vs. Tigres UANL    @ Estadio Azteca
Sáb 4 Ene  Monterrey             vs. Cruz Azul      @ Estadio Tecnológico
Sáb 4 Ene  Pachuca               vs. Toluca         @ Estadio Hidalgo
Sáb 4 Ene  Jaguares de Chiapas   vs. Veracruz       @ Estadio Víctor M. Reyna
Sáb 4 Ene  Atlas                 vs. Tijuana        @ Estadio Jalisco
Dom 5 Ene  Universidad Nacional  vs. Puebla         @ Estadio Olímpico Universitario
Dom 5 Ene  Atlante               vs. León           @ Estadio Andrés Quintana Roo

Jornada 2  //  10, 11 y 12 de enero

Vie 10 Ene  Querétaro    vs. Universidad Nacional   @ Estadio La Corregidora
Vie 10 Ene  Tijuana      vs. América                @ Estadio Caliente
Sáb 11 Ene  Veracruz     vs. Atlante                @ Estadio Luis Pirata Fuente
Sáb 11 Ene  Cruz Azul    vs. Santos Laguna          @ Estadio Azul
Sáb 11 Ene  Tigres UANL  vs. Pachuca                @ Estadio Universitario
Sáb 11 Ene  León         vs. Atlas                  @ Estadio Nou Camp
Dom 12 Ene  Puebla       vs. Monterrey              @ Estadio Cuauhtémoc
Dom 12 Ene  Toluca       vs. Monarcas Morelia       @ Estadio Nemesio Díez
Dom 12 Ene  Guadalajara  vs. Jaguares de Chiapas    @ Estadio Omnilife
TXT
  clubs, rounds = parse_auto_conf( txt, lang: 'es' )

  assert_equal Hash(
   'Monarcas Morelia'=>2,
   'Querétaro'=>2,
   'Santos Laguna'=>2,
   'Guadalajara'=>2,
   'América'=>2,
   'Tigres UANL'=>2,
   'Monterrey'=>2,
   'Cruz Azul'=>2,
   'Pachuca'=>2,
   'Toluca'=>2,
   'Jaguares de Chiapas'=>2,
   'Veracruz'=>2,
   'Atlas'=>2,
   'Tijuana'=>2,
   'Universidad Nacional'=>2,
   'Puebla'=>2,
   'Atlante'=>2,
   'León'=>2 ), clubs

   assert_equal Hash(
     'Jornada 1  //  3, 4 y 5 de enero'    => { count: 1, match_count: 9},
     'Jornada 2  //  10, 11 y 12 de enero' => { count: 1, match_count: 9} ), rounds
  end
end   # class TestMatchAutoMx
