#############################################################################
##
## TruncationsOfPresentationsByProjectiveGradedModules package
##
## Copyright 2019, Martin Bies,       ULB Brussels
##
## Chapter Functors for the category of projective graded left modules
##
#############################################################################


##############################################
##
## Section Basic functionality for truncations
##
##############################################

# Truncation of projective graded modules
InstallMethod( TruncationOfProjectiveGradedModule,
               [ IsCAPCategoryOfProjectiveGradedLeftOrRightModulesObject, IsSemigroupForPresentationsByProjectiveGradedModules ],
  function( projective_module, semigroup_for_CAP )
    local rank, degree_list, new_degree_list, i;

    # check if the degree_group of the underlying homalg_graded_ring is free
    if not IsFree( DegreeGroup( UnderlyingHomalgGradedRing( projective_module ) ) ) then

      Error( "Currently truncations are only supported for modules over freely-graded rings" );
      return;

    fi;

    # next make a basic check to see if the semigroup is embedded into the degree group of the ring
    rank := Rank( DegreeGroup( UnderlyingHomalgGradedRing( projective_module ) ) );
    if EmbeddingDimension( semigroup_for_CAP ) <> rank then

      Error( "The semigroup is not contained in the degree_group of the graded ring" );
      return;

    fi;

    # now identify the degree_list of the module in question
    degree_list := DegreeList( projective_module );

    # now compute the embedding matrix and the degrees of the truncated module
    new_degree_list := [];
    for i in [ 1 .. Length( degree_list ) ] do

      # if the degree lies in the semigroup, then add this degree layer to the degree_list of the truncated module
      if PointContainedInSemigroup( semigroup_for_CAP, UnderlyingListOfRingElements( degree_list[ i ][ 1 ] ) ) then
        Add( new_degree_list, degree_list[ i ] );
      fi;

    od;

    # and finally return the object
    if IsCAPCategoryOfProjectiveGradedLeftModulesObject( projective_module ) then
      return CAPCategoryOfProjectiveGradedLeftModulesObject( new_degree_list,
                                                             UnderlyingHomalgGradedRing( projective_module ),
                                                             CapCategory( projective_module )!.constructor_checks_wished
                                                            );
    else
      return CAPCategoryOfProjectiveGradedRightModulesObject( new_degree_list,
                                                              UnderlyingHomalgGradedRing( projective_module ),
                                                              CapCategory( projective_module )!.constructor_checks_wished
                                                             );
    fi;

end );

# Embedding of truncation of projective graded module into the original module
InstallMethod( EmbeddingOfTruncationOfProjectiveGradedModule,
               [ IsCAPCategoryOfProjectiveGradedLeftOrRightModulesObject, IsSemigroupForPresentationsByProjectiveGradedModules ],
  function( projective_module, semigroup_for_CAP )
    local rank, degree_list, new_degree_list, embedding_matrix, counter, i, j, row, graded_ring, truncated_module;

    # check if the degree_group of the underlying homalg_graded_ring is free
    if not IsFree( DegreeGroup( UnderlyingHomalgGradedRing( projective_module ) ) ) then

      Error( "Currently truncations are only supported for freely-graded rings" );
      return;

    fi;

    # next check if semigroup_generator_list is valid
    rank := Rank( DegreeGroup( UnderlyingHomalgGradedRing( projective_module ) ) );
    if EmbeddingDimension( semigroup_for_CAP ) <> rank then

      Error( "The semigroup is not contained in the degree_group of the graded ring" );
      return;

    fi;

    # now compute the embedding matrix and the degrees of the truncated module
    degree_list := DegreeList( projective_module );
    new_degree_list := [];
    embedding_matrix := [];
    counter := 0;
    for i in [ 1 .. Length( degree_list ) ] do

      # if the degree lies in the semigroup, then add this degree layer to the degree_list of the truncated module
      if PointContainedInSemigroup( semigroup_for_CAP, UnderlyingListOfRingElements( degree_list[ i ][ 1 ] ) ) then

        # add this degree to the new_degree_list
        Add( new_degree_list, degree_list[ i ] );

        # now add rows to the embedding matrix
        for j in [ 1 .. degree_list[ i ][ 2 ] ] do

          row := List( [ 1 .. Rank( projective_module ) ], x -> 0 );
          row[ counter + j ] := 1;
          Add( embedding_matrix, row );

        od;

      fi;

      # increase the counter
      counter := counter + degree_list[ i ][ 2 ];

    od;

    # if new_degree_list is empty, the truncated module is the zero_module and the embedding is the zero_morphism
    if Length( new_degree_list ) = 0 then

      return ZeroMorphism( ZeroObject( CapCategory( projective_module ) ), projective_module );

    fi;

    # otherwise install the truncated module (and transpose the embedding_matrix for right_modules)
    graded_ring := UnderlyingHomalgGradedRing( projective_module );
    if IsCAPCategoryOfProjectiveGradedLeftModulesObject( projective_module ) then

      truncated_module := CAPCategoryOfProjectiveGradedLeftModulesObject( new_degree_list,
                                                                    graded_ring,
                                                                    CapCategory( projective_module )!.constructor_checks_wished
                                                                    );

    else

      embedding_matrix := TransposedMat( embedding_matrix );
      truncated_module := CAPCategoryOfProjectiveGradedRightModulesObject( new_degree_list,
                                                                    graded_ring,
                                                                    CapCategory( projective_module )!.constructor_checks_wished
                                                                    );

    fi;

    # finally return the embedding
    return CAPCategoryOfProjectiveGradedLeftOrRightModulesMorphism( truncated_module,
                                                                    HomalgMatrix( embedding_matrix, graded_ring ),
                                                                    projective_module,
                                                                    CapCategory( projective_module )!.constructor_checks_wished
                                                                   );

end );

# Projection onto truncation of projective graded module
InstallMethod( ProjectionOntoTruncationOfProjectiveGradedModule,
               [ IsCAPCategoryOfProjectiveGradedLeftOrRightModulesObject, IsSemigroupForPresentationsByProjectiveGradedModules ],
  function( projective_module, semigroup_for_CAP )
    local rank, degree_list, new_degree_list, projection_matrix, counter, i, j, row, graded_ring, truncated_module;

    # check if the degree_group of the underlying homalg_graded_ring is free
    if not IsFree( DegreeGroup( UnderlyingHomalgGradedRing( projective_module ) ) ) then

      Error( "Currently truncations are only supported for freely-graded rings" );
      return;

    fi;

    # next check if semigroup_generator_list is valid
    rank := Rank( DegreeGroup( UnderlyingHomalgGradedRing( projective_module ) ) );
    if EmbeddingDimension( semigroup_for_CAP ) <> rank then

      Error( "The semigroup is not contained in the degree_group of the graded ring" );
      return;

    fi;

    # now compute the embedding matrix and the degrees of the truncated module
    degree_list := DegreeList( projective_module );
    new_degree_list := [];
    projection_matrix := [];
    counter := 0;
    for i in [ 1 .. Length( degree_list ) ] do

      # if the degree lies in the semigroup, then add this degree layer to the degree_list of the truncated module
      if PointContainedInSemigroup( semigroup_for_CAP, UnderlyingListOfRingElements( degree_list[ i ][ 1 ] ) ) then

        # add this degree to the new_degree_list
        Add( new_degree_list, degree_list[ i ] );

        # now add rows to the embedding matrix
        for j in [ 1 .. degree_list[ i ][ 2 ] ] do

          row := List( [ 1 .. Rank( projective_module ) ], x -> 0 );
          row[ counter + j ] := 1;
          Add( projection_matrix, row );

        od;

      fi;

      # increase the counter
      counter := counter + degree_list[ i ][ 2 ];

    od;

    # if the new_dgree_list is empty, the truncated module is the zero_module and the embedding is the zero_morphism
    if Length( new_degree_list ) = 0 then

      return ZeroMorphism( projective_module, ZeroObject( CapCategory( projective_module ) ) );

    fi;

    # otherwise install the truncated module (and transpose the embedding_matrix for right_modules)
    graded_ring := UnderlyingHomalgGradedRing( projective_module );
    if IsCAPCategoryOfProjectiveGradedLeftModulesObject( projective_module ) then

      projection_matrix := TransposedMat( projection_matrix );
      truncated_module := CAPCategoryOfProjectiveGradedLeftModulesObject( new_degree_list, 
                                                                    graded_ring,
                                                                    CapCategory( projective_module )!.constructor_checks_wished
                                                                    );

    else

      truncated_module := CAPCategoryOfProjectiveGradedRightModulesObject( new_degree_list, 
                                                                    graded_ring,
                                                                    CapCategory( projective_module )!.constructor_checks_wished
                                                                    );

    fi;

    # and return the corresponding embedding    
    return CAPCategoryOfProjectiveGradedLeftOrRightModulesMorphism( projective_module,
                                                                    HomalgMatrix( projection_matrix, graded_ring ),
                                                                    truncated_module,
                                                                    CapCategory( projective_module )!.constructor_checks_wished
                                                                   );

end );

# Embedding of truncation of projective graded module into the original module
InstallMethod( EmbeddingOfTruncationOfProjectiveGradedModuleWithGivenTruncationObject,
               [ IsCAPCategoryOfProjectiveGradedLeftOrRightModulesObject,
                 IsCAPCategoryOfProjectiveGradedLeftOrRightModulesObject ],
  function( projective_module, truncated_projective_module )
    local degree_list, truncated_degree_list, embedding_matrix, counter, counter2, iterator, i, j, row, graded_ring;

    # check for valid input
    if not IsIdenticalObj( CapCategory( projective_module ), CapCategory( truncated_projective_module ) ) then

      Error( "The modules have to be defined over the same category" );
      return;

    elif not IsFree( DegreeGroup( UnderlyingHomalgGradedRing( projective_module ) ) ) then

      Error( "Currently truncations are only supported for freely-graded rings" );
      return;

    fi;

    # if truncated_projective_module is the zero object, then the embedding is the zero_morphism
    if Rank( truncated_projective_module ) = 0 then

      return ZeroMorphism( ZeroObject( CapCategory( projective_module ) ), projective_module );

    fi;

    # extract the degree_lists
    degree_list := DegreeList( projective_module );
    truncated_degree_list := List( [ 1 .. Length( DegreeList( truncated_projective_module ) ) ],
                                   k -> ShallowCopy( DegreeList( truncated_projective_module )[ k ] ) );

    # given that the truncated_module is not the trivial module, we compute the non-trivial embedding matrix
    embedding_matrix := [];
    counter := 0;
    counter2 := 1;
    i := 1;
    iterator := true;
    while iterator do

      # if the degree belongs to the truncated module
      if degree_list[ i ] = truncated_degree_list[ counter2 ] then

        # now add rows to the embedding matrix
        for j in [ 1 .. degree_list[ i ][ 2 ] ] do

          row := List( [ 1 .. Rank( projective_module ) ], x -> 0 );
          row[ counter + j ] := 1;
          Add( embedding_matrix, row );

        od;

        # adjust counter2 or truncated_degree_list accordingly
        if degree_list[ i ][ 2 ] = truncated_degree_list[ counter2 ][ 2 ] then
          counter2 := counter2 + 1;
        elif degree_list[ i ][ 2 ] < truncated_degree_list[ counter2 ][ 2 ] then
          truncated_degree_list[ counter2 ][ 2 ] := truncated_degree_list[ counter2 ][ 2 ] - degree_list[ i ][ 2 ];
        else
          Error( "Something went wrong - is the given truncation object corrupted" );
          return;
        fi;

        # if counter2 exceeds the length of truncated_degree_list, then the computation of the embedding_matrix is completed
        if counter2 > Length( truncated_degree_list ) then
          iterator := false;
        fi;

      fi;

      # increase the counter
      counter := counter + degree_list[ i ][ 2 ];

      # increase i
      i := i + 1;

      # if i exteeds the length of degree_list, then the computation of the embedding_matrix is completed
      if i > Length( degree_list ) then
        iterator := false;
      fi;

    od;

    # transpose the embedding_matrix if necessary
    if not IsCAPCategoryOfProjectiveGradedLeftModulesObject( projective_module ) then

      embedding_matrix := TransposedMat( embedding_matrix );

    fi;

    # and return the embedding
    graded_ring := UnderlyingHomalgGradedRing( projective_module );
    return CAPCategoryOfProjectiveGradedLeftOrRightModulesMorphism( truncated_projective_module,
                                                                    HomalgMatrix( embedding_matrix, graded_ring ),
                                                                    projective_module,
                                                                    CapCategory( projective_module )!.constructor_checks_wished
                                                                   );

end );

# Embedding of truncation of projective graded module into the original module
InstallMethod( ProjectionOntoTruncationOfProjectiveGradedModuleWithGivenTruncationObject,
               [ IsCAPCategoryOfProjectiveGradedLeftOrRightModulesObject,
                 IsCAPCategoryOfProjectiveGradedLeftOrRightModulesObject ],
  function( projective_module, truncated_projective_module )
    local degree_list, truncated_degree_list, projection_matrix, counter, counter2, iterator, i, j, row, graded_ring;

    # check for valid input
    if not IsIdenticalObj( CapCategory( projective_module ), CapCategory( truncated_projective_module ) ) then

      Error( "The modules have to be defined over the same category" );
      return;

    elif not IsFree( DegreeGroup( UnderlyingHomalgGradedRing( projective_module ) ) ) then

      Error( "Currently truncations are only supported for freely-graded rings" );
      return;

    fi;

    # if the truncated module is the zero_module, then the projection is the zero_morphism
    if Rank( truncated_projective_module ) = 0 then

      return ZeroMorphism( projective_module, ZeroObject( CapCategory( projective_module ) ) );

    fi;

    # extract the degree_lists
    degree_list := DegreeList( projective_module );
    truncated_degree_list := List( [ 1 .. Length( DegreeList( truncated_projective_module ) ) ],
                                   k -> ShallowCopy( DegreeList( truncated_projective_module )[ k ] ) );

    # given that the truncated_module is not the trivial module, we compute the non-trivial embedding matrix
    projection_matrix := [];
    counter := 0;
    counter2 := 1;
    i := 1;
    iterator := true;
    while iterator do

      # if the degree belongs to the truncated module...
      if degree_list[ i ][ 1 ] = truncated_degree_list[ counter2 ][ 1 ] then

        # now add rows to the projection matrix
        for j in [ 1 .. degree_list[ i ][ 2 ] ] do

          row := List( [ 1 .. Rank( projective_module ) ], x -> 0 );
          row[ counter + j ] := 1;
          Add( projection_matrix, row );

        od;

        # adjust counter2 or truncated_degree_list accordingly
        if degree_list[ i ][ 2 ] = truncated_degree_list[ counter2 ][ 2 ] then
          counter2 := counter2 + 1;
        elif degree_list[ i ][ 2 ] < truncated_degree_list[ counter2 ][ 2 ] then
          truncated_degree_list[ counter2 ][ 2 ] := truncated_degree_list[ counter2 ][ 2 ] - degree_list[ i ][ 2 ];
        else
          Error( "Something went wrong - is the given truncation object corrupted" );
          return;
        fi;

        # if counter2 exceeds the length of truncated_degree_list, then the computation of the embedding_matrix is completed
        if counter2 > Length( truncated_degree_list ) then
          iterator := false;
        fi;

      fi;

      # increase the counter
      counter := counter + degree_list[ i ][ 2 ];

      # increase i
      i := i + 1;

      # if i exteeds the length of degree_list, then the computation of the embedding_matrix is completed
      if i > Length( degree_list ) then
        iterator := false;
      fi;

    od;

    # transpose the embedding_matrix if necessary
    if IsCAPCategoryOfProjectiveGradedLeftModulesObject( projective_module ) then

      projection_matrix := TransposedMat( projection_matrix );

    fi;

    # and return the projection
    graded_ring := UnderlyingHomalgGradedRing( projective_module );
    return CAPCategoryOfProjectiveGradedLeftOrRightModulesMorphism( projective_module,
                                                                    HomalgMatrix( projection_matrix, graded_ring ),
                                                                    truncated_projective_module,
                                                                    CapCategory( projective_module )!.constructor_checks_wished
                                                                   );

end );

#################################################
##
#! @Section The truncation functor
##
#################################################


# this function computes the trunction functor for both left and right presentations
InstallGlobalFunction( TruncationFunctorForProjectiveGradedModulesToSemigroups,
  function( graded_ring, semigroup_for_CAP, left )
    local rank, i, category, functor;

    # check if the degree_group of the underlying homalg_graded_ring is free
    if not IsFree( DegreeGroup( graded_ring ) ) then

      Error( "Currently truncations are only supported for freely-graded rings" );
      return;

    fi;

    # next check if the cone_h_list is valid
    rank := Rank( DegreeGroup( graded_ring ) );
    if EmbeddingDimension( semigroup_for_CAP ) <> rank then

      Error( "The semigroup is not contained in the degree_group of the graded ring" );
      return;

    fi;

    # first compute the category under consideration
    if left = true then
      category := CAPCategoryOfProjectiveGradedLeftModules( graded_ring );
    else
      category := CAPCategoryOfProjectiveGradedRightModules( graded_ring );
    fi;

    functor := CapFunctor( 
                      Concatenation( "Truncation functor for ", Name( category ), " to the semigroup generated by ", 
                                     String( GeneratorList( semigroup_for_CAP ) ) ), 
                      category,
                      category
                      );

    # now define the functor operation on the objects
    AddObjectFunction( functor,
      function( object )

        return TruncationOfProjectiveGradedModule( object, semigroup_for_CAP );

      end );

    # now define the functor operation on the morphisms
    AddMorphismFunction( functor,
      function( new_source, morphism, new_range )

        return PreCompose( [
               EmbeddingOfTruncationOfProjectiveGradedModuleWithGivenTruncationObject( Source( morphism ), new_source ),
               morphism,
               ProjectionOntoTruncationOfProjectiveGradedModuleWithGivenTruncationObject( Range( morphism ), new_range )
                           ] );

      end );

    # finally return the functor
    return functor;

end );

# functor to compute the truncation of left-modules
InstallMethod( TruncationFunctorForProjectiveGradedLeftModules,
               [ IsHomalgGradedRing, IsSemigroupForPresentationsByProjectiveGradedModules ],
      function( graded_ring, semigroup_generator_list )

        return TruncationFunctorForProjectiveGradedModulesToSemigroups( graded_ring, 
                                                                        semigroup_generator_list, 
                                                                        true 
                                                                       );

end );

# functor to compute the truncation of right-modules
InstallMethod( TruncationFunctorForProjectiveGradedRightModules,
               [ IsHomalgGradedRing, IsSemigroupForPresentationsByProjectiveGradedModules ],
      function( graded_ring, semigroup_generator_list )

        return TruncationFunctorForProjectiveGradedModulesToSemigroups( graded_ring, 
                                                                        semigroup_generator_list, 
                                                                        false 
                                                                       );

end );