# Install/Load libraries
if (!require("pacman")) install.packages("pacman")
pacman::p_load(DiagrammeR)

# Draw Figure 1 
DiagrammeR::grViz("
      digraph mrdag {

      graph [rankdir=TB, layout=neato]

      node [shape=ellipse, height=0.3, width=0.3]
      w [label=<<I>w</I>>,pos='3,2!']

      node [shape=ellipse, height=0.3, width=0.3]
      P [label=<<I>p@_{x}</I>>,pos='2,1!']
      m [label=<<I>f@_{x}</I>>,pos='4,1!']
      
      node [shape=ellipse, height=0.2, width=0.2]
      zx [label=<<I>z@_{y}</I>>, pos='3,0!']
    
      
      P -> w 
      m -> w 
      zx -> P
      zx -> m

      }
      ", height = 400)

# I couldnt figure out how to place the selection gradients on each edge at the 
# correct position so I just added them on top of this figure using MS-Word! 
# I KNOW, THE HORROR! :(