"""empty message

Revision ID: 96c6cce8dede
Revises: 06123bbe2d59
Create Date: 2021-11-23 18:45:32.043311

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '96c6cce8dede'
down_revision = '06123bbe2d59'
branch_labels = None
depends_on = None


def upgrade(engine_name):
    globals()["upgrade_%s" % engine_name]()


def downgrade(engine_name):
    globals()["downgrade_%s" % engine_name]()





def upgrade_():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('plots', sa.Column('check', sa.String(length=255), nullable=True))
    op.add_column('plots', sa.Column('analyze', sa.String(length=255), nullable=True))
    # ### end Alembic commands ###


def downgrade_():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('plots', 'analyze')
    op.drop_column('plots', 'check')
    # ### end Alembic commands ###


def upgrade_stats():
    # ### commands auto generated by Alembic - please adjust! ###
    pass
    # ### end Alembic commands ###


def downgrade_stats():
    # ### commands auto generated by Alembic - please adjust! ###
    pass
    # ### end Alembic commands ###

