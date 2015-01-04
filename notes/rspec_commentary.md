# Rspec - Context is King

The following example is unfair - because it is garbage-y generator-generated spec code. So - get over
that part. None of us really use generators (when anybody is looking). Just accept it as an
example of not making full use *context*.

I only bring this up because it seems to me that most folks are following the first example: they explicitly
repeat common context across many examples.

But later, as my context evolves into more interesting and varied
scenarios, I don't want to have to change multiple instances of the common parts of the context.

Frankly, I
think the first code block looks a lot like JUnit circa 2002. I remember when JUnit tests would
repeat many lines of setup (or context) in order to vary one or two lines that make up the variations
in scenarios.

What's the difference between the two sample code blocks below? The first one repeats the expression
of this bit of context in every single example:

* `PUT update` gets called

Whereas the second block isolates the *one* bit of context that's actually changing:

* the *input parameters* are either valid or invalid.

Repeating the context for each example (the one I don't like):

      describe "PUT update" do
        context "with valid params" do
          let(:new_attributes) {
            { name: 'updated idea name', description: 'updated description',
              passion_rating: 2, skill_rating: 3, profit_rating: 4 }
          }

          it "updates the requested idea" do
            idea = Idea.create! valid_attributes
            put :update, { :id => idea.to_param, :idea => new_attributes }, valid_session
            idea.reload
            expect(idea.name).to eq new_attributes[:name]
            expect(idea.description).to eq new_attributes[:description]
            expect(idea.passion_rating).to eq new_attributes[:passion_rating]
            expect(idea.skill_rating).to eq new_attributes[:skill_rating]
            expect(idea.profit_rating).to eq 1
          end

          it "assigns the requested idea as @idea" do
            idea = Idea.create! valid_attributes
            put :update, { :id => idea.to_param, :idea => valid_attributes }, valid_session
            expect(assigns(:idea)).to eq(idea)
          end

          it "redirects to the idea" do
            idea = Idea.create! valid_attributes
            put :update, { :id => idea.to_param, :idea => valid_attributes }, valid_session
            expect(response).to redirect_to(idea)
          end
        end

        context "with invalid params" do
          it "assigns the idea as @idea" do
            idea = Idea.create! valid_attributes
            put :update, { :id => idea.to_param, :idea => invalid_attributes }, valid_session
            expect(assigns(:idea)).to eq(idea)
          end

          it "re-renders the 'edit' template" do
            idea = Idea.create! valid_attributes
            put :update, { :id => idea.to_param, :idea => invalid_attributes }, valid_session
            expect(response).to render_template("edit")
          end
        end
      end

Here's the way I like it:

      describe "PUT update" do
        let(:idea) { Idea.create! valid_attributes }

        before do
          put :update, { :id => idea.to_param, :idea => update_attributes }, valid_session
          idea.reload
        end

        context "with valid params" do
          let(:update_attributes) {
            { name: 'updated idea name', description: 'updated description', passion_rating: 2, skill_rating: 3, profit_rating: 4 }
          }

          it "updates the requested idea" do
            expect(idea[:name]).to eq update_attributes[:name]
            expect(idea[:description]).to eq update_attributes[:description]
            expect(idea[:passion_rating]).to eq update_attributes[:passion_rating]
            expect(idea[:skill_rating]).to eq update_attributes[:skill_rating]
            expect(idea[:profit_rating]).to eq update_attributes[:profit_rating]
          end

          it "assigns the requested idea as @idea" do
            expect(assigns(:idea)).to eq(idea)
          end

          it "redirects to the idea" do
            expect(response).to redirect_to(idea)
          end
        end

        context "with invalid params" do
          let(:update_attributes) {
            { name: nil }
          }

          it "assigns the idea as @idea" do
            expect(assigns(:idea)).to eq(idea)
          end

          it "re-renders the 'edit' template" do
            expect(response).to render_template("edit")
          end
        end
      end
