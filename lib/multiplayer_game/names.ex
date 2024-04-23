defmodule MultiplayerGame.Names do
  def generate do
    title =
      ~w(Sir Sr Prof Saint Ibn Lady Madam Mistress Herr Dr Frau Dra Sra 1st 2nd The)
      |> Enum.random()

    name =
      [
        ~w(B C D F G H J K L M N P Q R S T V W X Z),
        ~w(o a i ij e é ê ee ei u uu oo aj aa oe ou eu),
        ~w(b c ç d f g h k l m n p q r rr s ss sch lh nh ñ t v w x z),
        ~w(o a i ij e ee  é ê es ues éis óis l u uu oo aj aa oe ou eu ü ë ä ö)
      ]
      |> Enum.map(fn l -> Enum.random(l) end)
      |> Enum.join()

    "#{title} #{name}"
  end
end
